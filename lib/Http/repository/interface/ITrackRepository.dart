import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

abstract class ITrackRepository {
  Future<bool> postNewTrackToPlaylist(
      {required String trackID, required String playlistID});

  Future<TrackDetailsModel> getTrackById({required String trackId});

  Future<List<String>> getArtistById({required String artistId});

  Future<dynamic> getUserTopItems({required String filter, int limit = 10});

  Future<TrackAudioFeaturesModel> getTrackFeaturesById(
      {required String trackId});

  Future<List<TrackDetailsModel>> getRecommendedTrack(
      {String artistId, String trackId, String genres});

  Future<bool> createPlayback({required Map<String, List<String>> uris});
}
