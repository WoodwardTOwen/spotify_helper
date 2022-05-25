import 'package:flutter/material.dart';
import 'package:spotify_helper/models/playlist_model.dart';

import '../../screens/playlist_items_screen.dart';
import '../misc/network_image.dart';

class PlaylistTileListView extends StatelessWidget {
  final PlaylistModel _currentItem;

  const PlaylistTileListView(this._currentItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PlaylistItemsScreen.routeName,
            arguments: _currentItem);
      },
      child: ListTile(
        leading: SizedBox(
          height: 60,
          width: 60,
          child: MyNetworkImageNotCached(
            playlistImageUrl: _currentItem.playlistImageUrl,
          ),
        ),
        title: Text(
          _currentItem.name,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          _currentItem.owner.displayName,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
