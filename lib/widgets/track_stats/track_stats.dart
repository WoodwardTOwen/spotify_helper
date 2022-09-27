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
        Align(
            alignment: Alignment.centerLeft,
            child: Text(statTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ))),
        Align(
            alignment: Alignment.centerRight,
            child: Text(statValue,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
