import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_helper/Http/bloc/playlist_tracks/bloc/playlist_tracks_bloc.dart';
import 'package:spotify_helper/models/playlist_model.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Http/services/api_path.dart';
import '../widgets/user_stats/track_tile.dart';

class PlaylistItemsScreen extends StatelessWidget {
  static const routeName = '/playlist-items';

  const PlaylistItemsScreen({Key? key}) : super(key: key);

  void _navigateToAnotherScreen(String currentPlaylistId) async {
    if (!await launchUrl(
        Uri.parse(ApiPath.reRouteToPlaylistInApp(currentPlaylistId)))) {
      throw 'Could not launch $currentPlaylistId playlist';
    }
  }

  Widget _createErrorMessage(String errorMessage) {
    return Text(errorMessage, style: const TextStyle(color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlaylistModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Items'),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MyNetworkImageNotCached(
                              playlistImageUrl: args.playlistImageUrl),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            args.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: ((ctx, index) => TrackTile(
                                  trackItem: state.tracks[index],
                                )),
                            itemCount: state.tracks.length,
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (!Platform.isIOS)
                            ElevatedButton(
                                child: const Text('...go to playlist'),
                                onPressed: () =>
                                    _navigateToAnotherScreen(args.id)),
                        ],
                      ),
                    )
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
