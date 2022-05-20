import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/Http/bloc/playlist/playlist_bloc_bloc.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/widgets/playlist/playlist_tile_grid_view.dart';
import 'package:spotify_helper/widgets/spotify_helper_drawer.dart';

import '../models/user_model.dart';

// Side note - the bridging for the iOS application is not finished ( up to set -Objc Linker flag) -
// Documentation - https://developer.spotify.com/documentation/ios/quick-start/

class Home extends StatefulWidget {
  static const routeName = '/home-page';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  late UserModel _currentUser;
  var isFiltered = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser
        .catchError((onError) {
      print(onError
          .toString()); //TODO Handle this occurance -> Re-Route to another page?
    }).then((value) {
      setState(() {
        _isLoading = false;
        _currentUser = value;
      });
    });
  }

  //TODO maybe reform the playlist filter to use the BLOCSelector instead

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
            appBar: AppBar(
              title: const Text(
                'Spotify Helper',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter),
                  onPressed: () {
                    setState(
                      () {
                        isFiltered = !isFiltered;
                      },
                    );
                  },
                )
              ],
            ),
            drawer: SpotifyHelperDrawer(user: _currentUser),
            body: Center(
              child: BlocBuilder<PlaylistBloc, PlaylistBlocState>(
                builder: (ctx, state) {
                  if (state is PlaylistBlocLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  if (state is PlaylistBlocLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async => ctx
                          .read<PlaylistBloc>()
                          .add(RefreshMyPlaylistsEvent()),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                isFiltered
                                    ? "Playlists by ${_currentUser.displayName}"
                                    : "All Saved Playlists",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                itemBuilder: ((ctx, index) {
                                  return PlayListTileGridView(
                                    isFiltered
                                        ? state.getFilteredResult(
                                            _currentUser.userId)[index]
                                        : state.playlists[index],
                                  );
                                }),
                                itemCount: isFiltered
                                    ? state
                                        .getFilteredResult(_currentUser.userId)
                                        .length
                                    : state.playlists.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                              ),
                            )
                          ])),
                    );
                  } else if (state is PlaylistFailureState) {
                    return Text(
                        'Something Went Wrong: ${state.error.toString()}, \n Please Try Again',
                        style: const TextStyle(color: Colors.black));
                  } else {
                    return const Text('Something Went Wrong, Please Try Again',
                        style: TextStyle(color: Colors.black));
                  }
                },
              ),
            ),
          );
  }
}
