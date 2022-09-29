import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';

/*
Can make this dynamic by creating a Key Value pair and then mapping the widget dynamically for the render process
For now just keeping it simple
*/

class PercentageIndicatorWidget extends StatelessWidget {
  final TrackAudioFeaturesModel trackAudioFeaturesModel;
  final int popularity;

  const PercentageIndicatorWidget({
    Key? key,
    required this.trackAudioFeaturesModel,
    required this.popularity,
  }) : super(key: key);

  Widget _buildCircularWidget(
      int percentageValue, String statTitle, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Text(
              statTitle,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width / 2,
              lineHeight: 8.0,
              linearStrokeCap: LinearStrokeCap.roundAll,
              percent: percentageValue / 100,
              progressColor: _caclulateColourForPercentile(percentageValue),
            ),
          ),
        ],
      ),
    );
  }

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
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircularWidget((trackAudioFeaturesModel.energy * 100).toInt(),
              "Energy", context),
          _buildCircularWidget(
              (trackAudioFeaturesModel.danceability * 100).toInt(),
              "Danceability",
              context),
          _buildCircularWidget((trackAudioFeaturesModel.valence * 100).toInt(),
              "Valence", context),
          _buildCircularWidget(
            popularity,
            "Track Popularity",
            context,
          ),
        ],
      ),
    );
  }
}
