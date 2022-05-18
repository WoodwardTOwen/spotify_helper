import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';
import 'package:spotify_helper/models/playlist_model.dart';

part 'playlist_bloc_event.dart';
part 'playlist_bloc_state.dart';

class PlaylistBloc extends Bloc<PlaylistBlocEvent, PlaylistBlocState> {
  final PlaylistRepository playlistRepository = PlaylistRepository();

  //We need events that handle errors and such -> not everything is through rose tinted glasses ofc

  PlaylistBloc() : super(PlaylistBlocLoadingState()) {
    on<PlaylistBlocEvent>(
      (event, emit) async {
        if (event is MyPlaylistsFetchedEvent ||
            event is RefreshMyPlaylistsEvent) {
          emit(PlaylistBlocLoadingState());
          try {
            final playlists = await playlistRepository.getPlaylistInformation();
            emit(PlaylistBlocLoaded(playlists: playlists));
          } catch (e) {
            emit(FailedToLoadState(error: e.toString()));
          }
        }
      },
    );
  }
}
