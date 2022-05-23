import '../../../models/playlist_model.dart';
import '../../../models/track_model.dart';

abstract class IPlaylistRepository {
  Future<List<PlaylistModel>> getPlaylistInformation({int limit, int offset});

  Future<List<TrackModel>> getListOfTrackModel(
      {required String searchItemId, required int offset, required int limit});

  Future<List<TrackModel>> getSearchedTrackResults(String searchedForValue);
}
