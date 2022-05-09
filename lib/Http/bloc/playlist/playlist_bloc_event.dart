part of 'playlist_bloc_bloc.dart';

abstract class PlaylistBlocEvent extends Equatable {
  const PlaylistBlocEvent();

  @override
  List<Object> get props => [];
}

class MyPlaylistsFetched extends PlaylistBlocEvent {}
