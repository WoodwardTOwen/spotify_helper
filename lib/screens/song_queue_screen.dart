import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/screens/playlists/playlists_screen.dart';
import '../models/action_enum.dart';
import '../providers/tracks_provider.dart';
import '../util/helper_methods.dart';
import '../widgets/misc/network_image.dart';

class SongQueueScreen extends StatefulWidget {
  static const routeName = '/song-queue';

  const SongQueueScreen({Key? key}) : super(key: key);

  @override
  State<SongQueueScreen> createState() => _SongQueueState();
}

class _SongQueueState extends State<SongQueueScreen> {
  late TrackProvider _trackProvider;
  final assetsAudioPlayer = AssetsAudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      await assetsAudioPlayer.open(
        Audio.network(trackPreviewUrl),
      );
    } catch (t) {
      print(t);
    }
    await assetsAudioPlayer.play();
  }

  void _discardTrack() async {
    await assetsAudioPlayer.stop();
    _trackProvider.removeFirstItemFromRecommendedTracksList();
    _startTrack(
        _trackProvider.getRecommendedTracksListForTest.first.previewUrl);
  }

  void _saveTrack(String trackId) async {
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

  Future<void> _getTrackPreviewUrlTest() async {
    //get the first 5 of the list and then call the recommendations function
    await _trackProvider.getRecommendedTracksTest();
    _startTrack(
        _trackProvider.getRecommendedTracksListForTest.first.previewUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spotder")),
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: FutureBuilder(
        future: _getTrackPreviewUrlTest(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TrackProvider>(
                      builder: (ctx, data, _) => Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () => print('In Progress'),
                                        icon: const Icon(Icons.volume_mute)),
                                  ]),
                              Column(children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: MyNetworkImageNotCached(
                                    playlistImageUrl: data
                                        .getRecommendedTracksListForTest
                                        .first
                                        .albumImageUrl,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  data.getRecommendedTracksListForTest.first
                                      .trackName,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  data.getRecommendedTracksListForTest.first
                                      .artist,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ]),
                            ],
                          )),
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
                              onTap: () => _discardTrack(),
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
                              onTap: () => _saveTrack(_trackProvider
                                  .getRecommendedTracksListForTest
                                  .first
                                  .trackId),
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
