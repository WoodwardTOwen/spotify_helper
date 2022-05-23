part of 'playlist_tracks_bloc.dart';

abstract class PlaylistTracksState extends Equatable {
  const PlaylistTracksState();

  @override
  List<Object> get props => [];
}

class PlaylistTracksInitial extends PlaylistTracksState {}

class PlaylistTracksLoading extends PlaylistTracksState {}

class PlaylistTracksLoaded extends PlaylistTracksState {
  final List<TrackModel> tracks;

  const PlaylistTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class PlaylistTracksFailure extends PlaylistTracksState {
  final String error;

  const PlaylistTracksFailure({required this.error});
}
