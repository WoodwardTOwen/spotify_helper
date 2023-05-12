import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/Http/bloc/recommended_tracks/recommened_tracks_bloc.dart';
import 'package:spotify_helper/screens/playlists/playlists_screen.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../models/action_enum.dart';
import '../models/track_details_model.dart';
import '../providers/tracks_provider.dart';
import '../util/helper_methods.dart';
import '../widgets/misc/network_image.dart';

class Spotder extends StatefulWidget {
  static const routeName = '/spotder';

  const Spotder({Key? key}) : super(key: key);

  static Widget create() {
    return BlocProvider<RecommendedTracksBloc>(
      create: (_) =>
          RecommendedTracksBloc()..add(RecommendedTracksFetchedEvent()),
      child: const Spotder(),
    );
  }

  @override
  State<Spotder> createState() => _SpotderState();
}

class _SpotderState extends State<Spotder> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RecommendedTracksBloc _recommendedTracksBloc;
  final _audioPlayer = AudioPlayer();
  final AppinioSwiperController controller = AppinioSwiperController();
  List<TrackDetailsModel> currentList = [];
  int currentCardIndex = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _audioPlayer.stop();
    } else if (state == AppLifecycleState.resumed) {
      _audioPlayer.play();
    }
  }

  @override
  void initState() {
    _recommendedTracksBloc = BlocProvider.of<RecommendedTracksBloc>(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _createErrorMessage(String errorMessage) {
    return Text(errorMessage, style: const TextStyle(color: Colors.white));
  }

  void _addNewTrack(String trackId, BuildContext context) async {
    await _audioPlayer.pause();
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
          builder: (context) => const PlaylistsScreen(
            playlistAction: PlaylistAction.onAddTrack,
          ),
        ))
        .then(
          (value) async => {
            if (value != null)
              {
                await Provider.of<TrackProvider>(context, listen: false)
                    .postNewTrack(trackID: trackId, playlistID: value as String)
                    .then(
                      (value) async => {
                        if (value)
                          {
                            HelperMethods.showGenericDialog(
                                context, "Track has been successfully added",
                                title: "Success!"),
                            await _audioPlayer.play()
                          }
                        else
                          {
                            HelperMethods.showGenericDialog(context,
                                "Something went wrong with adding the track, please try again"),
                          },
                      },
                    ),
              }
          },
        );
  }

  void _startTrack(String trackPreviewUrl) async {
    try {
      await _audioPlayer.setUrl(
        trackPreviewUrl,
      );
    } catch (t) {
      print(t);
    }
    await _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Spotder")),
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(49, 47, 47, .5),
        body: BlocBuilder<RecommendedTracksBloc, RecommendedTracksState>(
          builder: (ctx, state) {
            if (state is RecommendedTracksLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (state is RecommendedTracksLoaded) {
              currentList = state.recommendedTracksList;
              _startTrack(state.recommendedTracksList.first.previewUrl);
              return Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(49, 47, 47, .5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, top: 10),
                                      child: IconButton(
                                          onPressed: () => controller.unswipe(),
                                          icon: const Icon(
                                            Icons.undo,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ]),
                              SizedBox(
                                height: 450, //TODO needs to be dynamic
                                child: AppinioSwiper(
                                  swipeOptions: AppinioSwipeOptions.horizontal,
                                  unlimitedUnswipe: true,
                                  controller: controller,
                                  unswipe: _unswipe,
                                  onSwipe: _swipe,
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    top: 15,
                                    bottom: 50,
                                  ),
                                  onEnd: _onEnd,
                                  cardsCount:
                                      state.recommendedTracksList.length,
                                  cardsBuilder:
                                      (BuildContext context, int index) {
                                    return Center(
                                        child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(state
                                              .recommendedTracksList[index]
                                              .albumImageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      //I blured the parent container to blur background image, you can get rid of this part
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10.0, sigmaY: 10.0),
                                          child: Container(
                                            width: 300,
                                            //you can change opacity with color here(I used black) for background.
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 150,
                                                      width: 150,
                                                      child:
                                                          MyNetworkImageNotCached(
                                                        playlistImageUrl: state
                                                            .recommendedTracksList[
                                                                index]
                                                            .albumImageUrl,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      state
                                                          .recommendedTracksList[
                                                              index]
                                                          .trackName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: GoogleFonts
                                                                  .montserrat()
                                                              .fontFamily,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      state
                                                          .recommendedTracksList[
                                                              index]
                                                          .artist,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: GoogleFonts
                                                                  .montserrat()
                                                              .fontFamily,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
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
                                        controller.swipeLeft();
                                      },
                                      child: const SizedBox(
                                          width: 65,
                                          height: 65,
                                          child: Icon(Icons.close)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async => await _audioPlayer
                                        .seek(const Duration(seconds: 0)),
                                    icon: const Icon(Icons.refresh)),
                                ClipOval(
                                  child: Material(
                                    color: Colors.white, // Button color
                                    child: InkWell(
                                      splashColor: Colors.green, // Splash color
                                      onTap: () async {
                                        controller.swipeRight();
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
                  ));
            } else if (state is RecommendedTracksFailureState) {
              return _createErrorMessage(
                  'Something Went Wrong: ${state.error.toString()}, \n Please Try Again');
            }
            return Container();
          },
        ));
  }

  void _swipe(int index, AppinioSwiperDirection direction) async {
    if (direction == AppinioSwiperDirection.right) {
      _addNewTrack(currentList[index - 1].trackId, context);
      if (currentList.length - 1 >= index) {
        _startTrack(currentList[index].previewUrl);
      }
    } else if (direction == AppinioSwiperDirection.left) {
      //await _stopTrack();
      if (currentList.length - 1 >= index) {
        _startTrack(currentList[index].previewUrl);
      }
    }
    currentCardIndex++;
  }

  void _unswipe(bool unswiped) async {
    if (unswiped) {
      currentCardIndex--;
      _startTrack(currentList[currentCardIndex].previewUrl);
    } else {
      print("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    currentCardIndex = 0;
    _recommendedTracksBloc.emit(RecommendedTracksLoadingState());
    _recommendedTracksBloc.add(RecommendedTracksFetchedEvent());
  }
}
