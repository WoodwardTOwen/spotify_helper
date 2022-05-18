import 'package:flutter/material.dart';
import 'package:spotify_helper/models/playlist_model.dart';

class PlaylistTileFinder extends StatelessWidget {
  final PlaylistModel _foundPlaylistItem;

  const PlaylistTileFinder({required PlaylistModel foundPlaylistItem})
      : _foundPlaylistItem = foundPlaylistItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _foundPlaylistItem.name,
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
