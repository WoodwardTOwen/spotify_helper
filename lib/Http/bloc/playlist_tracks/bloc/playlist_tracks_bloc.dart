import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';

import '../../../../models/track_model.dart';

part 'playlist_tracks_event.dart';
part 'playlist_tracks_state.dart';

class PlaylistTracksBloc
    extends Bloc<PlaylistTracksEvent, PlaylistTracksState> {
  final PlaylistRepository playlistRepository = PlaylistRepository();

  PlaylistTracksBloc() : super(PlaylistTracksInitial()) {
    on<PlaylistTracksEvent>((event, emit) async {
      if (event is MyPlaylistItemsFetchedEvent) {
        emit(PlaylistTracksLoading());
        try {
          final tracks = await playlistRepository.getListOfTrackModel(
              searchItemId: event.playlistId, offset: 0, limit: 20);
          emit(PlaylistTracksLoaded(tracks: tracks));
        } catch (e) {
          emit(PlaylistTracksFailure(error: e.toString()));
        }
      }
    });
  }
}
