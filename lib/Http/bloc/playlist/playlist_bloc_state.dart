part of 'playlist_bloc_bloc.dart';

abstract class PlaylistBlocState extends Equatable {
  const PlaylistBlocState();

  @override
  List<Object> get props => [];
}

class PlaylistBlocInitialState extends PlaylistBlocState {}

class PlaylistBlocLoadingState extends PlaylistBlocState {}

@immutable
abstract class PlaylistWithData extends PlaylistBlocState {
  final List<PlaylistModel> playlists;

  const PlaylistWithData(this.playlists);

  List<PlaylistModel> getFilteredResult(String userId) =>
      playlists.where((playlist) => playlist.owner.userId == userId).toList();

  String getCurrentPlaylistName(String id) {
    return playlists.firstWhere((currentItem) => currentItem.id == id).name;
  }

  @override
  List<Object> get props => [playlists];
}

class PlaylistRefreshingState extends PlaylistWithData {
  const PlaylistRefreshingState(List<PlaylistModel> playlists)
      : super(playlists);
}

class PlaylistBlocLoaded extends PlaylistRefreshingState {
  final List<PlaylistModel> playlists;
  final bool hasReachedMax;

  const PlaylistBlocLoaded(
      {required this.playlists, required this.hasReachedMax})
      : super(playlists);

  PlaylistBlocLoaded copyWith(
          {List<PlaylistModel>? playlists, bool? hasReachedMax}) =>
      PlaylistBlocLoaded(
          playlists: playlists ?? this.playlists,
          hasReachedMax: hasReachedMax ?? this.hasReachedMax);

  @override
  List<Object> get props => [playlists];
}

class PlaylistFailureState extends PlaylistBlocState {
  final String error;

  const PlaylistFailureState({required this.error});
}
