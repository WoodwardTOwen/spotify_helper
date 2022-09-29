import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/track_repository.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

class TrackProvider with ChangeNotifier {
  TrackDetailsModel? _trackDetailsModel;
  TrackAudioFeaturesModel? _trackAudioFeaturesModel;
  List<String> currentArtistGenres = [];

  List<TrackDetailsModel> currentRecommendedTracks = [];

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

  Future<void> getArtistGenresByTrackId({required String artistId}) async {
    currentArtistGenres =
        await trackRepository.getArtistById(artistId: artistId);
  }

  Future<void> createPlayback({required String trackId}) async {
    final response = await trackRepository.createPlayback(uris: {
      "uris": [
        "spotify:track:$trackId",
      ],
    });

    //boolean response to update the UI with a response code
  }

  Future<void> getRecommendationsForTrack() async {
    final response = await trackRepository.getRecommendedTrack(
        artistId: _trackDetailsModel!.artistID[0],
        trackId: _trackDetailsModel!.trackId,
        genres: currentArtistGenres.length == 1
            ? currentArtistGenres[0]
            : filterAndJoinThreeGenres());
    currentRecommendedTracks = response;
    notifyListeners();
  }

  String filterAndJoinThreeGenres() => currentArtistGenres.isEmpty
      ? ""
      : currentArtistGenres.getRange(0, 2).join(', ');

  TrackDetailsModel? getTrackDetails() => _trackDetailsModel;
  TrackAudioFeaturesModel? getTrackAudioFeatures() => _trackAudioFeaturesModel;
}
