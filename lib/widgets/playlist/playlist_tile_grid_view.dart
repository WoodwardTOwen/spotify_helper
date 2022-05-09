import 'package:flutter/material.dart';
import 'package:spotify_helper/models/playlist_model.dart';

class PlayListTileGridView extends StatelessWidget {
  final PlaylistModel _currentItem;

  const PlayListTileGridView(this._currentItem);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {},
          child: Image.network(
            _currentItem.playlistImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            _currentItem.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
