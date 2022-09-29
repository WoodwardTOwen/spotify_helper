import 'package:flutter/material.dart';

import '../../models/track_details_model.dart';

class TrackStats extends StatelessWidget {
  final TrackDetailsModel _trackDetailsModel;

  const TrackStats({required trackDetailsModel})
      : _trackDetailsModel = trackDetailsModel;

  Widget _buildStat(String statTitle, String statValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(statTitle,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black87,
                    fontSize: 13,
                  ))),
        ),
        Flexible(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(statValue,
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black54,
                    fontSize: 13,
                  ))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStat("Appears On:", _trackDetailsModel.album.albumName),
          const SizedBox(
            height: 5,
          ),
          _buildStat(
              "Album Release Date:", _trackDetailsModel.album.albumReleaseDate),
        ],
      ),
    );
  }
}
