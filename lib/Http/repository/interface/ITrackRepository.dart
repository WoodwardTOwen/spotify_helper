import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

abstract class ITrackRepository {
  Future<bool> postNewTrackToPlaylist(
      {required String trackID, required String playlistID});

  Future<TrackDetailsModel> getTrackById({required String trackId});

  Future<TrackAudioFeaturesModel> getTrackFeaturesById(
      {required String trackId});
}
