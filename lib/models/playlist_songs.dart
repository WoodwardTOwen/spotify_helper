class PlaylistSongs {
  //This needs an auto increment
  int? id;
  final int playlistId;
  final int trackId;

  PlaylistSongs(this.playlistId, this.trackId);
}
