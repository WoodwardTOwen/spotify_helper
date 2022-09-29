import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/models/track_model.dart';
import 'package:spotify_helper/providers/tracks_provider.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';

class TrackTile extends StatelessWidget {
  final TrackModel _trackItem;
  final int indexValue;
  final bool isTrailing;

  const TrackTile(
      {required trackItem, this.indexValue = 0, this.isTrailing = false})
      : _trackItem = trackItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 40,
        width: 40,
        child: MyNetworkImageNotCached(
          playlistImageUrl: _trackItem.albumImageUrl,
        ),
      ),
      title: Text(
        indexValue == 0
            ? _trackItem.trackName
            : "${indexValue.toString()}. ${_trackItem.trackName}",
        style: const TextStyle(
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      subtitle: Text(
        _trackItem.artist,
        style: const TextStyle(
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      trailing: isTrailing ? _buildTrailing(context, _trackItem.trackId) : null,
    );
  }

  Widget _buildTrailing(BuildContext context, String trackId) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            onPressed: () => Provider.of<TrackProvider>(context, listen: false)
                .createPlayback(trackId: trackId),
          ),
          ImageIcon(
            const AssetImage("images/spotify.png"),
            color: Theme.of(context).colorScheme.primary,
            size: 15,
          ),
        ],
      );
}
