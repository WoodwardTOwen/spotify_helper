import 'package:flutter/material.dart';
import 'package:spotify_helper/models/found_playlist_item.dart';

class PlaylistTileFinder extends StatelessWidget {
  final FoundPlaylistItem _foundPlaylistItem;

  const PlaylistTileFinder({required FoundPlaylistItem foundPlaylistItem})
      : _foundPlaylistItem = foundPlaylistItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _foundPlaylistItem.playlistName,
        style: const TextStyle(
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
        ),
      ),
      trailing: CircleAvatar(
        backgroundImage: NetworkImage(
          _foundPlaylistItem.playlistImageUrl,
        ),
      ),
    );
  }
}
