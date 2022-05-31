import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/Http/bloc/playlist/playlist_bloc_bloc.dart';
import 'package:spotify_helper/models/action_enum.dart';
import 'package:spotify_helper/providers/playlist_finder_provider.dart';
import 'package:spotify_helper/screens/playlist_items_screen.dart';
import 'package:spotify_helper/screens/playlists_screen.dart';
import 'package:spotify_helper/util/helper_methods.dart';
import 'package:spotify_helper/widgets/misc/generic_header.dart';
import 'package:spotify_helper/widgets/playlist_finder_widgets/playlist_finder_loading_screen.dart';
import 'package:spotify_helper/widgets/playlist_finder_widgets/playlist_tile_finder.dart';

import '../models/track_model.dart';

class SearchAllPlaylistsScreen extends StatefulWidget {
  static const routeName = '/search-all-playlists';

  const SearchAllPlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<SearchAllPlaylistsScreen> createState() => _SearchAllPlaylistsState();
}

class _SearchAllPlaylistsState extends State<SearchAllPlaylistsScreen> {
  late PlaylistFinderProvider _playlistFinderProvider;

  Future<void> _beginSearch(
      String itemId, String itemTrack, String itemArtist) async {
    await Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getPlaylistFromRemote();

    await Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getAllPlaylistsContainingSearchItemId(itemId, itemTrack, itemArtist);
  }

  void _addNewTrack(String trackId) async {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
          builder: (context) => const PlaylistsScreen(
            playlistAction: PlaylistAction.onAddTrack,
          ),
        ))
        .then(
          (value) async => {
            await Provider.of<PlaylistFinderProvider>(context, listen: false)
                .postNewTrack(trackID: trackId, playlistID: value as String)
                .then(
                  (value) => {
                    if (value)
                      {
                        HelperMethods.showGenericDialog(
                            context, "Track has been successfully added",
                            title: "Success!"),
                        Navigator.of(context).pop()
                      }
                    else
                      {
                        HelperMethods.showGenericDialog(context,
                            "Something went wrong with adding the track, please try again"),
                      }
                  },
                ),
          },
        );
  }

  @override
  void didChangeDependencies() {
    _playlistFinderProvider =
        Provider.of<PlaylistFinderProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _playlistFinderProvider.disposeSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TrackModel;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
        body: FutureBuilder(
          future: _beginSearch(args.trackId, args.trackName, args.artist),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? PlaylistFinderLoadingScreen(trackName: args.trackName)
              : SafeArea(
                  child: Column(
                    children: [
                      GenericHeader(
                          imageUrl: args.albumImageUrl,
                          titleText: args.trackName,
                          subtitleText: args.artist),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Provider.of<PlaylistFinderProvider>(context,
                                    listen: false)
                                .getListOfPlaylistsForDesiredTrack
                                .isNotEmpty
                            ? const Text(
                                "Appears In...",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24),
                              )
                            : const Text(
                                "Whoops, this is awkward...",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                      ),
                      Expanded(
                        child: Consumer<PlaylistFinderProvider>(
                          builder: (ctx, data, _) => data
                                  .getListOfPlaylistsForDesiredTrack.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "This track doesn't exist in any of your playlists! Would you like to add it to one?",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          onPressed: () async =>
                                              _addNewTrack(args.trackId),
                                          child: const Text(
                                            'Add to Playlist',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemBuilder: (ctx, index) =>
                                      PlaylistTileFinder(
                                    foundPlaylistItem:
                                        data.getListOfPlaylistsForDesiredTrack[
                                            index],
                                  ),
                                  itemCount: data
                                      .getListOfPlaylistsForDesiredTrack.length,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Try Another Search')),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
