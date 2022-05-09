import 'package:floor/floor.dart';

import '../../models/playlist_model.dart';

//Methods are just filler for now until i get it set up correctly

@dao
abstract class PlaylistModelDao {
  @insert //(onConflict: OnConflictStrategy.replace) //This needs editing - needs a conflict strategy
  Future<void> insertPlaylist(PlaylistModel playlist);

  @update
  Future<void> updatePlaylist(PlaylistModel playlist);

  @delete
  Future<void> deletePlaylist(PlaylistModel playlist);

  @Query('SELECT * FROM PlaylistModel')
  Future<List<PlaylistModel>> getAllPlaylists();

  @Query('SELECT * FROM PlaylistModel WHERE id = :id')
  Future<PlaylistModel> findPlaylistById(String id);
}
