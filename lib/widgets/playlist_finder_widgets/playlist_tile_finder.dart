import 'package:flutter/material.dart';
import 'package:spotify_helper/models/playlist_model.dart';

import '../misc/network_image.dart';

class PlaylistTileFinder extends StatelessWidget {
  final PlaylistModel _foundPlaylistItem;

  const PlaylistTileFinder({required PlaylistModel foundPlaylistItem})
      : _foundPlaylistItem = foundPlaylistItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: MyNetworkImageNotCached(
          playlistImageUrl: _foundPlaylistItem.playlistImageUrl,
        ),
      ),
      title: Text(
        _foundPlaylistItem.name,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        _foundPlaylistItem.owner.displayName,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
