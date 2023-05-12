import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_helper/Http/repository/track_repository.dart';
import 'package:spotify_helper/Http/repository/user_stat_repository.dart';
import 'package:spotify_helper/models/track_details_model.dart';
import 'package:spotify_helper/util/helper_methods.dart';

import '../../../models/track_model.dart';

part 'recommened_tracks_event.dart';
part 'recommened_tracks_state.dart';

class RecommendedTracksBloc
    extends Bloc<RecommendedTracksEvent, RecommendedTracksState> {
  final TrackRepository trackRepository =
      TrackRepository(); //TODO methods from these repo's need merging
  final UserStatRepository userStatRepository = UserStatRepository();

  RecommendedTracksBloc() : super(RecommendedTracksLoadingState()) {
    on<RecommendedTracksEvent>(
        ((event, emit) => _onMyPlaylistFetchedEvent(event, emit)));
  }

  void _onMyPlaylistFetchedEvent(RecommendedTracksEvent event,
      Emitter<RecommendedTracksState> emit) async {
    if (event is RecommendedTracksFetchedEvent && !_hasReachedMax(state)) {
      try {
        if (state is RecommendedTracksLoadingState) {
          final responseUserTopItems = await userStatRepository
              .getUsersTopItems(timeFrame: 'short_term', limit: 5, offset: 0);

          final listOfRecommendedTracks = await getListOfRecommendedTracks(
              trackRepository: trackRepository,
              listOfUserTopItems: responseUserTopItems);

          emit(RecommendedTracksLoaded(
              recommendedTracksList: listOfRecommendedTracks,
              hasReachedMax: false,
              listOfUserTopItems: responseUserTopItems));
        } else if (state is RecommendedTracksLoaded) {
          final responseUserTopItems =
              await userStatRepository.getUsersTopItems(
                  timeFrame: 'short_term',
                  limit: 5,
                  offset: (state as RecommendedTracksLoaded)
                      .listOfUserTopItems
                      .length);

          final listOfRecommendedTracks = await getListOfRecommendedTracks(
              listOfUserTopItems: responseUserTopItems,
              trackRepository: trackRepository);

          if (listOfRecommendedTracks.isNotEmpty) {
            emit(RecommendedTracksLoaded(
                recommendedTracksList: listOfRecommendedTracks,
                listOfUserTopItems:
                    (state as RecommendedTracksLoaded).listOfUserTopItems +
                        responseUserTopItems,
                hasReachedMax: false));
          }
        }
      } catch (exception) {
        emit(RecommendedTracksFailureState(error: exception.toString()));
      }
    }
  }
}

bool _hasReachedMax(RecommendedTracksState state) =>
    state is RecommendedTracksLoaded && state.hasReachedMax;

Future<List<TrackDetailsModel>> getListOfRecommendedTracks(
    {int trackLimit = 5,
    String timeFrame = 'short_term',
    required TrackRepository trackRepository,
    required List<TrackModel> listOfUserTopItems}) async {
  final listOfTrackIds = listOfUserTopItems.map((e) => e.trackId).toList();

  final jointListOfIds = listOfTrackIds.join(',');

  final listOfRecommendedTracks = await trackRepository.getRecommendedTrack(
      trackId: jointListOfIds, limit: 100);

  listOfRecommendedTracks.removeWhere((element) => element.previewUrl == '');

  listOfRecommendedTracks.unique((currentTrack) => currentTrack.trackId);

  return listOfRecommendedTracks;
}
