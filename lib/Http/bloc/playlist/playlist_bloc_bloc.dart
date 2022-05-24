import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';
import 'package:spotify_helper/models/playlist_model.dart';

part 'playlist_bloc_event.dart';
part 'playlist_bloc_state.dart';

class PlaylistBloc extends Bloc<PlaylistBlocEvent, PlaylistBlocState> {
  final PlaylistRepository playlistRepository = PlaylistRepository();

  PlaylistBloc() : super(PlaylistBlocLoadingState()) {
    /* on<PlaylistBlocEvent>(
      (event, emit) async {
        if (event is MyPlaylistsFetchedEvent ||
            event is RefreshMyPlaylistsEvent) {
          emit(PlaylistBlocLoadingState());
          try {
            final playlists = await playlistRepository.getPlaylistInformation(limit: 100, offset: 0);


/*           yield playlists.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MyPlaylistsSuccess(
                  playlists: currentState.playlists + playlists,
                  hasReachedMax: false); */
            
            emit(playlists.isEmpty
              ? this.state.
              : MyPlaylistsFetchedEvent(
                  playlists: playlists + playlists,
                  hasReachedMax: false));

            emit(
                PlaylistBlocLoaded(playlists: playlists, hasReachedMax: false));
          } catch (e) {
            emit(PlaylistFailureState(error: e.toString()));
          }
        }
      },
    ); */

    on<MyPlaylistsFetchedEvent>(((event, emit) => _mapMeMate(event, emit)));
    on<RefreshMyPlaylistsEvent>(((event, emit) => _mapMeMate(event, emit)));
  }

  void _mapMeMate(
      PlaylistBlocEvent event, Emitter<PlaylistBlocState> emit) async {
    if (event is MyPlaylistsFetchedEvent && !_hasReachedMax(state)) {
      try {
        if (state is PlaylistBlocLoadingState) {
          final playlists = await playlistRepository.getPlaylistInformation(
              limit: 20, offset: 0);
          emit(PlaylistBlocLoaded(playlists: playlists, hasReachedMax: false));
        } else if (state is PlaylistBlocLoaded) {
          final playlists = await playlistRepository.getPlaylistInformation(
              offset: (state as PlaylistBlocLoaded).playlists.length,
              limit: 20);
          emit(playlists.isEmpty
              ? (state as PlaylistBlocLoaded)
                  .copyWith(playlists: playlists, hasReachedMax: true)
              : PlaylistBlocLoaded(
                  playlists: playlists + playlists, hasReachedMax: false));
        }
      } catch (exception) {
        emit(PlaylistFailureState(error: exception.toString()));
      }
    }
/*     if (event is RefreshMyPlaylistsEvent) {
      try {
        if (state is PlaylistBlocLoaded)
          emit( R(currentState.playlists);
        final playlists = await SpotifyApi.getListOfPlaylists(
            offset: 0, limit: Constants.playlistsLimit);
        yield MyPlaylistsSuccess(playlists: playlists, hasReachedMax: false);
      } catch (e) {
        print(e);
        yield MyPlaylistsFailure();
      }
    } */
  }

  bool _hasReachedMax(PlaylistBlocState state) =>
      state is PlaylistBlocLoaded && state.hasReachedMax;
}
