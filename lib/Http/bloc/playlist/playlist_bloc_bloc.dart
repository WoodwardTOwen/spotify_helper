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
    on<MyPlaylistsFetchedEvent>(
        ((event, emit) => _onMyPlaylistFetchedEvent(event, emit)));
    on<RefreshMyPlaylistsEvent>(
        ((event, emit) => _onRefreshMyPlaylistEvent(event, emit)));
  }

  void _onMyPlaylistFetchedEvent(
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
              ? (state as PlaylistBlocLoaded).copyWith(hasReachedMax: true)
              : PlaylistBlocLoaded(
                  playlists:
                      (state as PlaylistBlocLoaded).playlists + playlists,
                  hasReachedMax: false));
        }
      } catch (exception) {
        emit(PlaylistFailureState(error: exception.toString()));
      }
    }
  }

  void _onRefreshMyPlaylistEvent(
      PlaylistBlocEvent event, Emitter<PlaylistBlocState> emit) async {
    try {
      if (state is PlaylistBlocLoaded) {
        emit(PlaylistRefreshingState((state as PlaylistBlocLoaded).playlists));
      }
      final playlists =
          await playlistRepository.getPlaylistInformation(limit: 20, offset: 0);
      emit(PlaylistBlocLoaded(playlists: playlists, hasReachedMax: false));
    } catch (exception) {
      emit(PlaylistFailureState(error: exception.toString()));
    }
  }
}

bool _hasReachedMax(PlaylistBlocState state) =>
    state is PlaylistBlocLoaded && state.hasReachedMax;
