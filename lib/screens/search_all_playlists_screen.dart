import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/playlist_finder_provider.dart';
import 'package:spotify_helper/widgets/playlist/playlist_finder_heading.dart';
import 'package:spotify_helper/widgets/playlist/playlist_finder_loading_screen.dart';
import 'package:spotify_helper/widgets/playlist/playlist_tile_finder.dart';

import '../models/track_model.dart';

class SearchAllPlaylistsScreen extends StatefulWidget {
  static const routeName = '/search-all-playlists';

  const SearchAllPlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<SearchAllPlaylistsScreen> createState() => _SearchAllPlaylistsState();
}

//TODO Create new UI for the album color/ naming
class _SearchAllPlaylistsState extends State<SearchAllPlaylistsScreen> {
  Future<void> _beginSearch(
      String itemId, String itemTrack, String itemArtist) async {
    await Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getPlaylistFromRemote();
    await Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getAllPlaylistsContainingSearchItemId(itemId, itemTrack, itemArtist);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TrackModel;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<PlaylistFinderProvider>(context, listen: false)
            .disposeSearch;
        return true;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _beginSearch(args.trackId, args.trackName, args.artist),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? PlaylistFinderLoadingScreen(trackName: args.trackName)
              : SafeArea(
                  child: Column(
                    children: [
                      PlaylistFinderHeading(track: args),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Appears In...",
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      ),
                      Expanded(
                        child: Consumer<PlaylistFinderProvider>(
                          builder: (ctx, data, _) => data
                                  .getListOfPlaylistsForDesiredTrack.isEmpty
                              ? const Center(
                                  child: Text(
                                      "This track doesn't exist in any of your playlists! Would you like to add it to one?",
                                      style: TextStyle(color: Colors.black)),
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
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Try Another Search'))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
