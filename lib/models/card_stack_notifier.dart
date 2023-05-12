import 'package:flutter/material.dart';
import 'package:spotify_helper/models/track_details_model.dart';

class CardStackNotifier extends ValueNotifier<List<TrackDetailsModel>> {
  CardStackNotifier({required List<TrackDetailsModel> value}) : super(value);

  void addTracksToList(List<TrackDetailsModel> newTracks) =>
      value.addAll(newTracks);

  void removeTrackByIndex(int index) => value.removeAt(index);
}
