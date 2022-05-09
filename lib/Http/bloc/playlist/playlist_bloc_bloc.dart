import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';
import 'package:spotify_helper/models/playlist_model.dart';

part 'playlist_bloc_event.dart';
part 'playlist_bloc_state.dart';

class PlaylistBlocBloc extends Bloc<PlaylistBlocEvent, PlaylistBlocState> {
  final PlaylistRepository playlistRepository = PlaylistRepository();

  //We need events that handle errors and such -> not everything is through rose tinted glasses ofc

  PlaylistBlocBloc() : super(PlaylistBlocInitial()) {
    on<MyPlaylistsFetched>(
      (event, emit) async {
        final playlists = await playlistRepository.getPlaylistInformation();
        emit(PlaylistBlocLoaded(playlists: playlists));
      },
    );
  }
}
