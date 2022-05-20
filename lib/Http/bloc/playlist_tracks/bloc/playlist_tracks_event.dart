part of 'playlist_tracks_bloc.dart';

abstract class PlaylistTracksEvent extends Equatable {
  const PlaylistTracksEvent();

  @override
  List<Object> get props => [];
}

class MyPlaylistItemsFetchedEvent extends PlaylistTracksEvent {
  final String playlistId;

  const MyPlaylistItemsFetchedEvent({required this.playlistId});
}
