import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/track_repository.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

import '../Http/services/api_path.dart';
import '../models/checklist_model.dart';

class TrackProvider with ChangeNotifier {
  TrackDetailsModel? _trackDetailsModel;
  TrackAudioFeaturesModel? _trackAudioFeaturesModel;
  List<String> currentArtistGenres = [];

  List<TrackDetailsModel> currentRecommendedTracks = [];

  List<TrackDetailsModel> queuedSongs =
      []; //Position of track in queue and Track itself //TODO REFORM TO MAP

  List<ChecklistModel> filteredSongQueueGenreList = [];
  final List<String> _currentGenreCheckList = [];

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

  Future<void> getGenresFromTopArtistItems() async {
    List<dynamic> genres = [];

    final response =
        await trackRepository.getUserTopItems(filter: ApiPath.artistFilter);

    List<dynamic> list =
        response.data['items'].map((element) => element['genres']).toList();

    for (var i = 0; i < list.length; i++) {
      genres.addAll(list[i].map((e) => e.toString()));
    }

    List<String> filtered = LinkedHashSet<String>.from(genres).toList();

    filteredSongQueueGenreList = filtered
        .map((e) => ChecklistModel(genreName: e, isChecked: false))
        .toList();

    notifyListeners();
  }

  Future<void> createPlayback({required String trackId}) async =>
      await trackRepository.createPlayback(uris: {
        "uris": [
          "spotify:track:$trackId",
        ],
      });

  //TODO MAKE DYNAMIC AND MERGE ONE BELOW

  Future<void> getRecommendationsForTrack() async {
    final response = await trackRepository.getRecommendedTrack(
        artistId: _trackDetailsModel!.artistID[0],
        trackId: _trackDetailsModel!.trackId,
        genres: currentArtistGenres.length == 1
            ? currentArtistGenres[0]
            : filterAndJoinGeneres(endRange: 2, list: currentArtistGenres));
    currentRecommendedTracks = response;
    notifyListeners();
  }

  Future<void> getRecommendationsForTrackQUEUE(String queue) async {
    final response = await trackRepository.getRecommendedTrack(genres: queue);
    queuedSongs = response;
    notifyListeners();
  }

  String filterAndJoinGeneres(
          {int startRange = 0,
          required int endRange,
          required List<String> list}) =>
      list.isEmpty ? "" : list.getRange(startRange, endRange).join(', ');

  TrackDetailsModel? getTrackDetails() => _trackDetailsModel;

  TrackAudioFeaturesModel? getTrackAudioFeatures() => _trackAudioFeaturesModel;

  //Checklist Filter Methods

  bool addNewItemToCheckListGenreList(String item) {
    if (_currentGenreCheckList.length == 5) {
      return false;
    }
    _currentGenreCheckList.add(item);
    return true;
  }

  void removeItemFromCheckListGenreList(String item) =>
      _currentGenreCheckList.removeWhere((element) => element == item);

  int getCurrentGenreCheckListListLength() => _currentGenreCheckList.length;

  void clearCurrentCheckListGenreList() => _currentGenreCheckList.clear();

  List<String> getCurrentCheckListGenreList() => _currentGenreCheckList;
}
