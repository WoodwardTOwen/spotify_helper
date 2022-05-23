import 'package:flutter/material.dart';
import 'package:spotify_helper/models/playlist_model.dart';
import 'package:spotify_helper/screens/playlist_items_screen.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';

class PlayListTileGridView extends StatelessWidget {
  final PlaylistModel _currentItem;

  const PlayListTileGridView(this._currentItem);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PlaylistItemsScreen.routeName,
                  arguments: _currentItem);
            },
            child: MyNetworkImageNotCached(
              playlistImageUrl: _currentItem.playlistImageUrl,
            )),
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
