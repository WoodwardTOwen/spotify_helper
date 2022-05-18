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

  const PlaylistBlocLoaded({required this.playlists});

  List<PlaylistModel> getFilteredResult(String userId) {
    return playlists
        .where((playlist) => playlist.owner.userId == userId)
        .toList();
  }

  @override
  List<Object> get props => [playlists];
}

class FailedToLoadState extends PlaylistBlocState {
  final String error;

  const FailedToLoadState({required this.error});
}
