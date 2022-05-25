import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/widgets/playlist_finder_widgets/playlist_tile_list_view.dart';
import '../Http/bloc/playlist/playlist_bloc_bloc.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
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
  UserModel? _currentUser;

  late PlaylistBloc _playlistBloc;
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  var isFiltered = false;

  void _onScrolledToEnd() {
    var isEnd = _controller.offset == _controller.position.maxScrollExtent;
    if (isEnd) _playlistBloc.add(MyPlaylistsFetchedEvent());
  }

  void _attemptToRetrieveCurrentUser() {
    Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser
        .catchError((onError) {
      setState(() {
        _isLoading = false;
        _currentUser = null;
      });
    }).then((value) {
      setState(() {
        _isLoading = false;
        _currentUser = value;
      });
    });
  }

  @override
  void initState() {
    _attemptToRetrieveCurrentUser();
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

  Widget _createErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Error trying to retrieve User, \n Would you like to retry?",
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              child: const Text("Retry"),
              onPressed: () => _attemptToRetrieveCurrentUser())
        ],
      ),
    );
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
            drawer: _currentUser == null
                ? null
                : SpotifyHelperDrawer(user: _currentUser!),
            body: _currentUser == null
                ? _createErrorWidget()
                : BlocBuilder<PlaylistBloc, PlaylistBlocState>(
                    builder: (ctx, state) {
                      if (state is PlaylistBlocLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is PlaylistWithData) {
                        final playlists = state.playlists;
                        return RefreshIndicator(
                          onRefresh: () async => _onRefresh(),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    isFiltered
                                        ? "Playlists by ${_currentUser!.displayName}"
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
                                        child: ListView.separated(
                                          controller: _controller,
                                          itemBuilder: ((ctx, index) {
                                            return PlaylistTileListView(
                                              isFiltered
                                                  ? state.getFilteredResult(
                                                      _currentUser!
                                                          .userId)[index]
                                                  : state.playlists[index],
                                            );
                                          }),
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                          itemCount: isFiltered
                                              ? state
                                                  .getFilteredResult(
                                                      _currentUser!.userId)
                                                  .length
                                              : state.playlists.length,
                                        ),
                                      ),
                              ],
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
