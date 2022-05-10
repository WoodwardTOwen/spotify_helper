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
        backgroundColor: Colors.transparent,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: MyNetworkImage(imageUrl: _trackItem.albumImageUrl)),
      ),
    );
  }
}
