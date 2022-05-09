import 'package:flutter/material.dart';
import 'package:spotify_helper/models/track_model.dart';

class TrackTile extends StatelessWidget {
  final TrackModel _trackItem;
  final int indexValue;

  const TrackTile({required trackItem, this.indexValue = 0})
      : _trackItem = trackItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        indexValue == 0
            ? "${_trackItem.trackName} by ${_trackItem.artist}"
            : "${indexValue.toString()}. ${_trackItem.trackName} by ${_trackItem.artist}",
        style: const TextStyle(
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
        ),
      ),
      trailing: CircleAvatar(
        backgroundImage: NetworkImage(
          _trackItem.albumImageUrl,
        ),
      ),
    );
  }
}
