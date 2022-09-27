import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';

/*
Can make this dynamic by creating a Key Value pair and then mapping the widget dynamically for the render process
For now just keeping it simple
*/

class PercentageIndicatorWidget extends StatelessWidget {
  final TrackAudioFeaturesModel trackAudioFeaturesModel;

  const PercentageIndicatorWidget(
      {Key? key, required this.trackAudioFeaturesModel})
      : super(key: key);

  Widget _buildCircularWidget(
      double radius, int percentageValue, String statTitle) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: radius,
            lineWidth: 4.0,
            percent: percentageValue / 100,
            center: Text("$percentageValue%"),
            progressColor: _caclulateColourForPercentile(percentageValue),
          ),
          Text(statTitle),
        ],
      ),
    );
  }

  //Used to determine what colour should be returned for the percentage indicator

  Color _caclulateColourForPercentile(int percentageValue) {
    if (percentageValue <= 25) {
      return Colors.red;
    } else if (percentageValue <= 45) {
      return Colors.orange;
    } else if (percentageValue <= 65) {
      return Colors.yellow;
    } else if (percentageValue <= 85) {
      return Colors.lightGreen;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(15.0),
            child: _buildCircularWidget(45, 59, "Popularity")),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCircularWidget(
                30, (trackAudioFeaturesModel.energy * 100).toInt(), "Energy"),
            _buildCircularWidget(
                30,
                (trackAudioFeaturesModel.danceability * 100).toInt(),
                "Danceability"),
            _buildCircularWidget(
                30, (trackAudioFeaturesModel.valence * 100).toInt(), "valence"),
          ],
        ),
      ],
    );
  }
}
