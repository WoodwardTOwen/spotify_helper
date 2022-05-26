import 'package:flutter/material.dart';
import 'package:spotify_helper/models/track_model.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';

class TrackTile extends StatelessWidget {
  final TrackModel _trackItem;
  final int indexValue;

  const TrackTile({required trackItem, this.indexValue = 0})
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
        maxLines: 2,
      ),
      subtitle: Text(
        _trackItem.artist,
        style: const TextStyle(
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
    );
  }
}
