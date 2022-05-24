part of 'playlist_bloc_bloc.dart';

abstract class PlaylistBlocState extends Equatable {
  const PlaylistBlocState();

  @override
  List<Object> get props => [];
}

class PlaylistBlocInitialState extends PlaylistBlocState {}

class PlaylistBlocLoadingState extends PlaylistBlocState {}

class PlaylistBlocLoaded extends PlaylistBlocState {
  final List<PlaylistModel> playlists;
  final bool hasReachedMax;

  const PlaylistBlocLoaded(
      {required this.playlists, required this.hasReachedMax});

  List<PlaylistModel> getFilteredResult(String userId) {
    return playlists
        .where((playlist) => playlist.owner.userId == userId)
        .toList();
  }

  PlaylistBlocLoaded copyWith(
          {required List<PlaylistModel> playlists,
          required bool hasReachedMax}) =>
      PlaylistBlocLoaded(playlists: playlists, hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [playlists];
}

class PlaylistFailureState extends PlaylistBlocState {
  final String error;

  const PlaylistFailureState({required this.error});
}
