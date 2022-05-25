import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/playlist_finder_provider.dart';
import 'package:spotify_helper/screens/search_all_playlists_screen.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/track_tile.dart';

class SearchForItemScreen extends StatefulWidget {
  static const routeName = '/search-for-items';

  const SearchForItemScreen({Key? key}) : super(key: key);

  @override
  State<SearchForItemScreen> createState() => _SearchForItemScreenState();
}

/**
 * TODO Create a nice loading screen to then load the data - info the user you're syncing data and stuff
 * TODO ALOT of error handling - the ting is very prone to dropping and messing up the system.
 */

class _SearchForItemScreenState extends State<SearchForItemScreen> {
  TextEditingController editingController = TextEditingController();
  bool _isLoading = false;

  void _onSubmit() {
    //Need to validate input of the submit
    if (editingController.text.isEmpty) {
      return;
    }

    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      _isLoading = true;
    });

    Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getSearchResults(editingController.text)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    Provider.of<PlaylistFinderProvider>(context, listen: false)
        .clearCachedSearchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      appBar: AppBar(
        title: const Text("Search All Playlists"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: editingController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async =>
                        _onSubmit(), //Still requires better error handling

                child: const Text("Search")),
            Consumer<PlaylistFinderProvider>(
              builder: ((ctx, searchResults, _) => searchResults
                      .getSearchedTrackResults.isEmpty
                  ? const Expanded(
                      child: Center(
                          child: Text(
                        "No Data Present",
                        style: TextStyle(color: Colors.black),
                      )),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: ((ctx, index) => GestureDetector(
                              child: TrackTile(
                                trackItem: searchResults
                                    .getSearchedTrackResults[index],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  ctx,
                                  SearchAllPlaylistsScreen.routeName,
                                  arguments: searchResults
                                      .getSearchedTrackResults[index],
                                );
                              },
                            )),
                        itemCount: searchResults.getSearchedTrackResults.length,
                      ),
                    )),
            )
          ],
        ),
      ),
    );
  }
}
