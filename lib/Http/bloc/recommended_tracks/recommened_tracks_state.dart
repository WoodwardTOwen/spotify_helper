part of 'recommened_tracks_bloc.dart';

abstract class RecommendedTracksState extends Equatable {
  const RecommendedTracksState();

  @override
  List<Object> get props => [];
}

class RecommendedTracksInitial extends RecommendedTracksState {}

class RecommendedTracksLoadingState extends RecommendedTracksState {}

@immutable
abstract class RecommenedTracksWithData extends RecommendedTracksState {
  final List<TrackDetailsModel> recommendedTracksList;
  final List<TrackModel> listOfUserTopItems;

  const RecommenedTracksWithData(
      this.recommendedTracksList, this.listOfUserTopItems);

  //This could filter out the bad shite in here
  List<TrackDetailsModel> getFilteredResult(String userId) =>
      recommendedTracksList.where((track) => track.previewUrl != '').toList();

  @override
  List<Object> get props => [recommendedTracksList, listOfUserTopItems];
}

class RecommendedTracksLoaded extends RecommenedTracksWithData {
  final List<TrackDetailsModel> recommendedTracksList;
  final List<TrackModel> listOfUserTopItems;
  final bool hasReachedMax;

  const RecommendedTracksLoaded(
      {required this.recommendedTracksList,
      required this.hasReachedMax,
      required this.listOfUserTopItems})
      : super(recommendedTracksList, listOfUserTopItems);

  RecommendedTracksLoaded copyWith(
          {List<TrackDetailsModel>? playlists,
          bool? hasReachedMax,
          List<TrackModel>? listOfUserTopItems}) =>
      RecommendedTracksLoaded(
          recommendedTracksList: recommendedTracksList,
          hasReachedMax: hasReachedMax ?? this.hasReachedMax,
          listOfUserTopItems: listOfUserTopItems!);

  @override
  List<Object> get props => [recommendedTracksList, listOfUserTopItems];
}

class RecommendedTracksFailureState extends RecommendedTracksState {
  final String error;

  const RecommendedTracksFailureState({required this.error});
}
