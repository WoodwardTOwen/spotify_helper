import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/track_repository.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

class TrackProvider with ChangeNotifier {
  TrackDetailsModel? _trackDetailsModel;
  TrackAudioFeaturesModel? _trackAudioFeaturesModel;

  TrackRepository trackRepository = TrackRepository();

  Future<bool> postNewTrack(
          {required String trackID, required String playlistID}) async =>
      await trackRepository.postNewTrackToPlaylist(
          trackID: trackID, playlistID: playlistID);

  Future<void> getTrackById({required String trackId}) async {
    _trackDetailsModel = await trackRepository.getTrackById(trackId: trackId);
    notifyListeners();
  }

  Future<void> getAudioFeaturesByTrackId({required String trackId}) async {
    _trackAudioFeaturesModel =
        await trackRepository.getTrackFeaturesById(trackId: trackId);
    notifyListeners();
  }

  TrackDetailsModel? getTrackDetails() => _trackDetailsModel;
  TrackAudioFeaturesModel? getTrackAudioFeatures() => _trackAudioFeaturesModel;
}
