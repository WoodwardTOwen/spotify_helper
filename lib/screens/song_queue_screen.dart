import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/screens/playlists/playlists_screen.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../models/action_enum.dart';
import '../models/track_details_model.dart';
import '../providers/tracks_provider.dart';
import '../util/helper_methods.dart';
import '../widgets/misc/network_image.dart';
import 'package:palette_generator/palette_generator.dart';

class SongQueueScreen extends StatefulWidget {
  static const routeName = '/song-queue';

  const SongQueueScreen({Key? key}) : super(key: key);

  @override
  State<SongQueueScreen> createState() => _SongQueueState();
}

class _SongQueueState extends State<SongQueueScreen> {
  late TrackProvider _trackProvider;
  final assetsAudioPlayer = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PaletteGenerator? paletteGenerator;

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;

  //int offset = 0;

  @override
  void initState() {
    _trackProvider = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  void _startTrack(String trackPreviewUrl) async {
    try {
      await assetsAudioPlayer.setUrl(
        trackPreviewUrl,
      );
    } catch (t) {
      print(t);
    }
    await assetsAudioPlayer.play();
  }

  Future<void> _discardTrack() async {
    await assetsAudioPlayer.stop();
    _trackProvider.removeFirstItemFromRecommendedTracksList();
    if (_trackProvider.getRecommendedTracksListForTest.isNotEmpty) {
      _startTrack(
          _trackProvider.getRecommendedTracksListForTest.first.previewUrl);
    }
  }

  Future<void> _saveTrack(String trackId) async {
    await assetsAudioPlayer.stop();
    _addNewTrack(trackId, _scaffoldKey.currentContext!);
  }

  //Extracted Method can be replicated if it works

  void _addNewTrack(String trackId, BuildContext context) async {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
          builder: (context) => const PlaylistsScreen(
            playlistAction: PlaylistAction.onAddTrack,
          ),
        ))
        .then(
          (value) async => {
            await Provider.of<TrackProvider>(context, listen: false)
                .postNewTrack(trackID: trackId, playlistID: value as String)
                .then(
                  (value) => {
                    if (value)
                      {
                        HelperMethods.showGenericDialog(
                            context, "Track has been successfully added",
                            title: "Success!"),
                        _discardTrack(),
                      }
                    else
                      {
                        HelperMethods.showGenericDialog(context,
                            "Something went wrong with adding the track, please try again"),
                      },
                  },
                ),
          },
        );
  }

  Future<void> _getTrackPreviewUrlTest() async {
    //get the first 5 of the list and then call the recommendations function
    final listOfRecommendedTracks =
        await _trackProvider.getRecommendedTracksTest();
    createCardItems(listOfRecommendedTracks);
    _startTrack(
        _trackProvider.getRecommendedTracksListForTest.first.previewUrl);
  }

  void createCardItems(List<TrackDetailsModel> tracks) {
    for (int i = 0; i < tracks.length; i++) {
      _swipeItems.add(
        SwipeItem(
          content: tracks[i],
          likeAction: () {
            _saveTrack(
                _trackProvider.getRecommendedTracksListForTest.first.trackId);
          },
          nopeAction: () async {
            await _discardTrack();
          },
        ),
      );
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Future<PaletteGenerator> _updatePaletteGenerator(String imageUrl) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(imageUrl).image,
    );
    return paletteGenerator!;
  }

  Color _convertColourToRGBO(Color colour) {
    return Color.fromRGBO(colour.red, colour.green, colour.blue, 0.4);
  }

  Color _checkIfPaletteIsInvalid(PaletteGenerator? paletteGenerator) {
    if (paletteGenerator!.dominantColor != null) {
      if (paletteGenerator.dominantColor?.color != null) {
        return paletteGenerator.dominantColor!.color;
      }
    }
    return Colors.white;
  }

  //Reform future builder to use snapshot data potentially??

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTrackPreviewUrlTest(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : /* Consumer<TrackProvider>(
                builder: (ctx, data, _) => FutureBuilder<PaletteGenerator>(
                  future: _updatePaletteGenerator(_trackProvider
                      .getRecommendedTracksListForTest
                      .first
                      .albumImageUrl), // async work
                  builder: (BuildContext context,
                          AsyncSnapshot<PaletteGenerator> snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              appBar: AppBar(title: const Text("Spotder")),
                              key: _scaffoldKey,
                              body: Center(
                                child: CircularProgressIndicator(),
                              ))
                          : */
          Scaffold(
              appBar: AppBar(title: const Text("Spotder")),
              key: _scaffoldKey,
              //backgroundColor: _convertColourToRGBO(
              //snapshot.data!.dominantColor!.color),
              backgroundColor: const Color.fromRGBO(49, 47, 47, .5),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                            onPressed: () => print('In Progress'),
                            icon: const Icon(
                              Icons.volume_mute,
                              color: Colors.white,
                            )),
                      ]),
                      SizedBox(
                        height: 450, //TODO needs to be dynamic
                        child: SwipeCards(
                          matchEngine: _matchEngine,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 300,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: MyNetworkImageNotCached(
                                          playlistImageUrl: _swipeItems[index]
                                              .content
                                              .albumImageUrl,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        _swipeItems[index].content.trackName,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      Text(
                                        _swipeItems[index].content.artist,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ]),
                              ),
                            );
                          },
                          onStackFinished: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Stack Finished"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          itemChanged: (SwipeItem item, int index) {
                            //print("item: ${item.content.text}, index: $index");
                          },
                          upSwipeAllowed: true,
                          fillSpace: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 0, right: 0, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () async {
                                _matchEngine.currentItem!.nope();
                                await _discardTrack();
                              },
                              child: const SizedBox(
                                  width: 65,
                                  height: 65,
                                  child: Icon(Icons.close)),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => _startTrack(_trackProvider
                                .getRecommendedTracksListForTest
                                .first
                                .previewUrl),
                            icon: const Icon(Icons.refresh)),
                        ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.green, // Splash color
                              onTap: () async {
                                _matchEngine.currentItem!.like();
                                await _saveTrack(_trackProvider
                                    .getRecommendedTracksListForTest
                                    .first
                                    .trackId);
                              },
                              child: const SizedBox(
                                  width: 65,
                                  height: 65,
                                  child: Icon(Icons.check)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}