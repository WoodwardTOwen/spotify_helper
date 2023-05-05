import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spotify_helper/models/action_enum.dart';
import 'package:spotify_helper/models/playlist_model.dart';
import '../../screens/playlists/playlist_items_screen.dart';
import '../misc/network_image.dart';

class PlaylistTileListView extends StatelessWidget {
  final PlaylistModel _currentItem;
  final PlaylistAction playlistAction;

  const PlaylistTileListView(this._currentItem,
      {this.playlistAction = PlaylistAction.onGenericLoad});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playlistAction != PlaylistAction.onGenericLoad
            ? Navigator.pop(context, _currentItem.id)
            : pushNewScreenWithRouteSettings(
                context,
                screen: const PlaylistItemsScreen(),
                settings: RouteSettings(arguments: _currentItem),
              );
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
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        subtitle: Text(
          _currentItem.owner.displayName,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
