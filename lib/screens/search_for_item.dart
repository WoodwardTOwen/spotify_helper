import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
  final TextEditingController _editingController = TextEditingController();
  bool _isLoading = false;

  void _onSubmit() {
    //Need to validate input of the submit
    if (_editingController.text.isEmpty) {
      return;
    }

    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      _isLoading = true;
    });

    Provider.of<PlaylistFinderProvider>(context, listen: false)
        .getSearchResults(_editingController.text)
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

  void _clear() {
    if (_editingController.value.text.isNotEmpty) {
      setState(() {
        _editingController.clear();
        Provider.of<PlaylistFinderProvider>(context, listen: false)
            .clearCachedSearchItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
        appBar: AppBar(
          title: const Text(
            "Search All Playlists",
            style: TextStyle(fontSize: 16),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _editingController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) async => _onSubmit(),
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    suffixIcon: _isLoading
                        ? Transform.scale(
                            scale: 0.6,
                            child: const CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: _clear, icon: const Icon(Icons.clear)),
                    prefixIcon: IconButton(
                        onPressed: () => _onSubmit(),
                        icon: const Icon(Icons.search)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Consumer<PlaylistFinderProvider>(
              builder: ((ctx, searchResults, _) => searchResults
                      .getSearchedTrackResults.isEmpty
                  ? const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Hint: Search For a Track!",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
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
                                pushNewScreenWithRouteSettings(
                                  context,
                                  screen: const SearchAllPlaylistsScreen(),
                                  settings: RouteSettings(
                                    arguments: searchResults
                                        .getSearchedTrackResults[index],
                                  ),
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
