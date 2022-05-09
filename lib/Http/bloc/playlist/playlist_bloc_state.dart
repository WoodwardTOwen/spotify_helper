part of 'playlist_bloc_bloc.dart';

abstract class PlaylistBlocState extends Equatable {
  const PlaylistBlocState();

  @override
  List<Object> get props => [];
}

class PlaylistBlocInitial extends PlaylistBlocState {}

class PlaylistBlocLoaded extends PlaylistBlocState {
  final List<PlaylistModel> playlists;

  const PlaylistBlocLoaded({required this.playlists});

  @override
  List<Object> get props => [playlists];
}
