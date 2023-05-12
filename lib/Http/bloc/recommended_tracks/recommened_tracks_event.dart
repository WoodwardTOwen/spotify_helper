part of 'recommened_tracks_bloc.dart';

abstract class RecommendedTracksEvent extends Equatable {
  const RecommendedTracksEvent();

  @override
  List<Object> get props => [];
}

class RecommendedTracksFetchedEvent extends RecommendedTracksEvent {}
