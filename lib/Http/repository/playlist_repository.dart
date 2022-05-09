import 'package:spotify_helper/models/found_playlist_item.dart';
import 'package:spotify_helper/util/dio_util.dart';

import '../../models/playlist_model.dart';
import '../../models/track_model.dart';
import '../services/api_path.dart';
import 'interface/IPlaylistRepository.dart';

class PlaylistRepository implements IPlaylistRepository {
  final client = DioUtil().getClient;

  //TODO Offset needs working around
  @override
  Future<List<PlaylistModel>> getPlaylistInformation() async {
    final response =
        await client.get(ApiPath.getListOfPlaylists(limit: 40, offset: 0));
    final list = response.data['items']
        .map((item) => PlaylistModel.fromJson(item))
        .toList();

    return List<PlaylistModel>.from(list);
  }

  //New ones go here - could always just use the top one instead
  @override
  Future<List<FoundPlaylistItem>> getSearchInformation() async {
    final response =
        await client.get(ApiPath.getListOfPlaylists(limit: 40, offset: 0));
    final list = await response.data['items']
        .map((item) => FoundPlaylistItem.fromJson(item))
        .toList();

    return List<FoundPlaylistItem>.from(list);
  }

  @override
  Future<List<TrackModel>> getListOfTrackModel(
      {required String searchItemId,
      required int offset,
      required int limit}) async {
    final response = await client.get(ApiPath.getListOfTracksByLimitAndOffset(
        offset: offset, limit: limit, playlistId: searchItemId));

    final temp = response.data['items']
        .map((item) => TrackModel.fromJson(item['track']))
        .toList();

    return List<TrackModel>.from(temp);
  }

  @override
  Future<List<TrackModel>> getSearchedTrackResults(
      String searchedForValue) async {
    final response = await client
        .get(ApiPath.searchForTrack(searchedTrack: searchedForValue));

    final list = response.data['tracks']['items']
        .map((item) => TrackModel.fromJson(item))
        .toList();

    return List<TrackModel>.from(list);
  }
}