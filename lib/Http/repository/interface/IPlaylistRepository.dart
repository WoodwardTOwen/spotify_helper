import '../../../models/found_playlist_item.dart';
import '../../../models/playlist_model.dart';
import '../../../models/track_model.dart';

abstract class IPlaylistRepository {
  Future<List<PlaylistModel>> getPlaylistInformation();

  //New ones go here - could always just use the top one instead
  Future<List<FoundPlaylistItem>> getSearchInformation();

  Future<List<TrackModel>> getListOfTrackModel(
      {required String searchItemId, required int offset, required int limit});

  Future<List<TrackModel>> getSearchedTrackResults(String searchedForValue);
}
