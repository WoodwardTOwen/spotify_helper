import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spotify_helper/Http/bloc/playlist_tracks/bloc/playlist_tracks_bloc.dart';
import 'package:spotify_helper/models/playlist_model.dart';
import 'package:spotify_helper/screens/track_details_screen.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/track_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Http/services/api_path.dart';
import '../util/helper_methods.dart';

class PlaylistItemsScreen extends StatelessWidget {
  static const routeName = '/playlist-items';

  const PlaylistItemsScreen({Key? key}) : super(key: key);

  void _showDialog(BuildContext context, String currentPlaylistId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Open Spotify',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          content: const Text('Do you wish to Open Spotify?'),
          actions: <Widget>[
            TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  HelperMethods.navigateToAnotherScreen(
                      ApiPath.reRouteToPlaylistInApp(currentPlaylistId));
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Widget _createErrorMessage(String errorMessage) {
    return Text(errorMessage, style: const TextStyle(color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlaylistModel;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      appBar: AppBar(
        title: Text(args.name, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
              icon: const ImageIcon(
                AssetImage("images/spotify.png"),
                color: Colors.white,
                size: 20,
              ),
              onPressed: () async {
                try {
                  !Platform.isIOS
                      ? _showDialog(context, args.id)
                      : HelperMethods.showGenericDialog(context,
                          'The iOS version of opening Spotify is not yet supported.');
                } catch (exception) {
                  HelperMethods.showGenericDialog(
                      context, "Failed to open Spotify, Please Try Again");
                }
              }),
        ],
      ),
      body: BlocProvider<PlaylistTracksBloc>(
        create: (ctx) {
          return PlaylistTracksBloc()
            ..add(MyPlaylistItemsFetchedEvent(playlistId: args.id));
        },
        child: Center(
          child: BlocBuilder<PlaylistTracksBloc, PlaylistTracksState>(
            builder: (ctx, state) {
              if (state is PlaylistTracksLoading) {
                return const CircularProgressIndicator();
              } else if (state is PlaylistTracksLoaded) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 125,
                              width: 125,
                              child: MyNetworkImageNotCached(
                                  playlistImageUrl: args.playlistImageUrl),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: ((ctx, index) => GestureDetector(
                                    child: TrackTile(
                                      trackItem: state.tracks[index],
                                    ),
                                    onTap: () => pushNewScreenWithRouteSettings(
                                      context,
                                      screen: const TrackDetailPage(),
                                      settings: RouteSettings(
                                          arguments:
                                              state.tracks[index].trackId),
                                    ),
                                  )),
                              itemCount: state.tracks.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is PlaylistTracksFailure) {
                return _createErrorMessage(
                    'Something Went Wrong: ${state.error.toString()}, \n Please Try Again');
              } else {
                return _createErrorMessage(
                    'Something Went Wrong, Please Try Again');
              }
            },
          ),
        ),
      ),
    );
  }
}
