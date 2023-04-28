import 'package:dio/dio.dart';
import 'package:spotify_helper/Http/repository/interface/ITrackRepository.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';

import '../../util/dio_util.dart';
import '../services/api_path.dart';

class TrackRepository implements ITrackRepository {
  final client = DioUtil().getClient;

  @override
  Future<bool> postNewTrackToPlaylist(
      {required String trackID, required String playlistID}) async {
    try {
      final response = await client.post(
          ApiPath.postNewTracktoPlaylist(playlistID: playlistID),
          options: Options(contentType: Headers.jsonContentType),
          data: ApiPath.createUriForSpotify(trackID));

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }

  @override
  Future<TrackDetailsModel> getTrackById({required String trackId}) async {
    try {
      final response = await client.get(ApiPath.getTrackById(trackId: trackId));
      return TrackDetailsModel.fromJson(response.data);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getArtistById({required String artistId}) async {
    try {
      final response =
          await client.get(ApiPath.getArtistById(artistId: artistId));
      return List<String>.from(response.data['genres']);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getUserTopItems(
      {required String filter, int limit = 10}) async {
    try {
      return await client
          .get(ApiPath.getUserTopItems(filter: filter, limit: limit));
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<TrackAudioFeaturesModel> getTrackFeaturesById(
      {required String trackId}) async {
    try {
      final response =
          await client.get(ApiPath.getAudioFeaturesById(trackId: trackId));
      return TrackAudioFeaturesModel.fromJson(response.data);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<List<TrackDetailsModel>> getRecommendedTrack(
      {String artistId = "", String trackId = "", String genres = ""}) async {
    try {
      final response = await client.get(ApiPath.getRecommendations(
          trackId: trackId, artistId: artistId, artistGenre: genres));
      final list = response.data['tracks']
          .map((item) => TrackDetailsModel.fromJson(item))
          .toList();
      return List<TrackDetailsModel>.from(list);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<bool> createPlayback({required Map<String, List<String>> uris}) async {
    try {
      final response = await client.put(ApiPath.createPlayback,
          options: Options(contentType: Headers.jsonContentType), data: uris);

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }
}
