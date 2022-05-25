import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/util/helper_methods.dart';

import '../Http/bloc/playlist/playlist_bloc_bloc.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/playlist_finder_widgets/playlist_tile_grid_view.dart';
import '../widgets/spotify_helper_drawer.dart';

class PlaylistsScreen extends StatefulWidget {
  static const routeName = '/playlist-screen';

  const PlaylistsScreen({Key? key}) : super(key: key);

  static Widget create() {
    return BlocProvider<PlaylistBloc>(
      create: (_) => PlaylistBloc()..add(MyPlaylistsFetchedEvent()),
      child: const PlaylistsScreen(),
    );
  }

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  bool _isLoading = true;
  late UserModel _currentUser;

  late PlaylistBloc _playlistBloc;
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  var isFiltered = false;

  //Add controller here

  void _onScrolledToEnd() {
    var isEnd = _controller.offset == _controller.position.maxScrollExtent;
    if (isEnd) _playlistBloc.add(MyPlaylistsFetchedEvent());
  }

  @override
  void initState() {
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

    _playlistBloc = BlocProvider.of<PlaylistBloc>(context);
    _controller.addListener(_onScrolledToEnd);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrolledToEnd);
    super.dispose();
  }

  Widget _createErrorMessage(String errorMessage) {
    return Text(errorMessage, style: const TextStyle(color: Colors.black));
  }

  Future<void> _onRefresh() async {
    _playlistBloc.add(RefreshMyPlaylistsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            backgroundColor: Color.fromRGBO(239, 234, 216, 1),
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
                  onPressed: () => setState(() => isFiltered = !isFiltered),
                )
              ],
            ),
            drawer: SpotifyHelperDrawer(user: _currentUser),
            body: BlocBuilder<PlaylistBloc, PlaylistBlocState>(
              builder: (ctx, state) {
                if (state is PlaylistBlocLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PlaylistWithData) {
                  final playlists = state.playlists;
                  return BlocListener<PlaylistBloc, PlaylistBlocState>(
                    listenWhen: (previous, current) =>
                        previous is PlaylistRefreshingState,
                    listener: (context, state) {
                      if (state is PlaylistBlocLoaded) {
                        HelperMethods.createSnackBarMessage(
                            context, "Finished Refreshing");
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: () async => _onRefresh(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
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
                            playlists.isEmpty
                                ? const Center(
                                    child: Text("No Playlists found!!"),
                                  )
                                : Expanded(
                                    child: GridView.builder(
                                      controller: _controller,
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
                                              .getFilteredResult(
                                                  _currentUser.userId)
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
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is PlaylistFailureState) {
                  return _createErrorMessage(
                      'Something Went Wrong: ${state.error.toString()}, \n Please Try Again');
                }
                return Container();
              },
            ),
          );
  }
}
