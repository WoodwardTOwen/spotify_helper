//Temp object
class FoundPlaylistItem {
  //Maybe include the image at a later time
  final String playlistId;
  final String playlistName;
  final int playlistTotalCount;
  final String playlistImageUrl;

  FoundPlaylistItem({
    required this.playlistId,
    required this.playlistName,
    required this.playlistTotalCount,
    required this.playlistImageUrl,
  });

  factory FoundPlaylistItem.fromJson(Map<String, dynamic> json) {
    return FoundPlaylistItem(
      playlistId: json['id'],
      playlistName: json['name'],
      playlistTotalCount: json['tracks']['total'],
      playlistImageUrl:
          json['images'].length != 0 ? json['images'][0]['url'] : "",
    );
  }
}
