part of 'playlist_bloc_bloc.dart';

@immutable
abstract class PlaylistBlocEvent extends Equatable {
  const PlaylistBlocEvent();

  @override
  List<Object> get props => [];
}

class MyPlaylistsFetchedEvent extends PlaylistBlocEvent {}

class RefreshMyPlaylistsEvent extends PlaylistBlocEvent {}
