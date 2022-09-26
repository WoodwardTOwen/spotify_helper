import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/track_repository.dart';
import 'package:spotify_helper/models/track_details_model.dart';

class TrackProvider with ChangeNotifier {
  //Need Track Repo here
  TrackRepository trackRepository = TrackRepository();

  Future<bool> postNewTrack(
          {required String trackID, required String playlistID}) async =>
      await trackRepository.postNewTrackToPlaylist(
          trackID: trackID, playlistID: playlistID);

  Future<TrackDetailsModel> getTrackById({required String trackId}) async {
    final response = await trackRepository.getTrackById(trackId: trackId);
    return response;
  }
}
