import 'package:floor/floor.dart';

@entity
class PlaylistSongs {
  @primaryKey //This needs an auto increment
  int? id;
  final int playlistId;
  final int trackId;

  PlaylistSongs(this.playlistId, this.trackId);
}
