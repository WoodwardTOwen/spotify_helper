import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/screens/queued_songs_screen.dart';
import 'package:spotify_helper/util/helper_methods.dart';
import '../models/checklist_model.dart';
import '../providers/tracks_provider.dart';

class GenreFilterScreen extends StatefulWidget {
  static const routeName = '/genre-filter';

  const GenreFilterScreen({Key? key}) : super(key: key);

  @override
  State<GenreFilterScreen> createState() => _GenreFilterScreenState();
}

class _GenreFilterScreenState extends State<GenreFilterScreen> {
  Future<void> _getTopArtistsForGenres(BuildContext buildContext) async =>
      await Provider.of<TrackProvider>(buildContext, listen: false)
          .getGenresFromTopArtistItems();

  String getCheckListArgument() {
    final list = Provider.of<TrackProvider>(context, listen: false)
        .getCurrentCheckListGenreList();
    return Provider.of<TrackProvider>(context, listen: false)
        .filterAndJoinGeneres(endRange: list.length, list: list);
  }

  void checkStatusOfGenreList() {
    if (Provider.of<TrackProvider>(context, listen: false)
            .getCurrentGenreCheckListListLength() !=
        0) {
      pushNewScreenWithRouteSettings(
        context,
        screen: const QueuedSongsScreen(),
        settings: RouteSettings(arguments: getCheckListArgument()),
      ).then((value) => Provider.of<TrackProvider>(context, listen: false)
          .clearCurrentCheckListGenreList());
    } else {
      HelperMethods.showGenericDialog(
          context, "Please select at least one genre to continue");
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
      TODO The args from the previous side will be useful once we have multiple categories that can help the filtering process 
    */

    //final categoryDetails = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick up to 5 Genres"),
        actions: [
          IconButton(
            onPressed: () => checkStatusOfGenreList(),
            icon: const Icon(
              Icons.done,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: FutureBuilder(
        future: _getTopArtistsForGenres(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Consumer<TrackProvider>(
                        builder: (ctx, data, _) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: ((ctx, index) => CheckBoxTest(
                                checklistItem:
                                    data.filteredSongQueueGenreList[index],
                              )),
                          itemCount: data.filteredSongQueueGenreList.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class CheckBoxTest extends StatefulWidget {
  ChecklistModel checklistItem;

  CheckBoxTest({Key? key, required this.checklistItem}) : super(key: key);

  @override
  State<CheckBoxTest> createState() => _CheckBoxTestState();
}

class _CheckBoxTestState extends State<CheckBoxTest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        tileColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.checklistItem.genreName,
          style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              color: Colors.white),
          maxLines: 1,
        ),
        value: widget.checklistItem.isChecked,
        onChanged: (val) {
          setState(
            () {
              if (val != null) {
                if (val) {
                  bool result =
                      Provider.of<TrackProvider>(context, listen: false)
                          .addNewItemToCheckListGenreList(
                              widget.checklistItem.genreName);
                  result ? widget.checklistItem.isChecked = val : null;
                } else {
                  Provider.of<TrackProvider>(context, listen: false)
                      .removeItemFromCheckListGenreList(
                          widget.checklistItem.genreName);
                  widget.checklistItem.isChecked = val;
                }
              }
            },
          );
        },
      ),
    );
  }
}
