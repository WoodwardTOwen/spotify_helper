import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/models/track_details_model.dart';
import 'package:spotify_helper/providers/tracks_provider.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';
import 'package:spotify_helper/widgets/track_stats/percentage_indicator_widget.dart';
import 'package:spotify_helper/widgets/track_stats/track_stats.dart';

class TrackDetailPage extends StatefulWidget {
  static const routeName = '/track-details';

  const TrackDetailPage({Key? key}) : super(key: key);

  @override
  State<TrackDetailPage> createState() => _TrackDetailPageState();
}

class _TrackDetailPageState extends State<TrackDetailPage> {
  late TrackProvider _trackProvider;

  @override
  void initState() {
    _trackProvider = Provider.of(context, listen: false);
    super.initState();
  }

  Future<void> _getTrackDetails(String trackId) async {
    await _trackProvider.getTrackById(trackId: trackId);
    await _trackProvider.getAudioFeaturesByTrackId(trackId: trackId);
  }

  Widget _createTitle(TrackDetailsModel trackDetailsModel) => Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              trackDetailsModel.trackName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const Text(
              "By",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(trackDetailsModel.artist,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final trackIdArgs = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      //backgroundColor: const Color.fromRGBO(128, 161, 212, 1),
      body: FutureBuilder(
        future: _getTrackDetails(trackIdArgs),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 125,
                        width: 125,
                        child: MyNetworkImage(
                            imageUrl: _trackProvider
                                .getTrackDetails()!
                                .albumImageUrl),
                      ),
                    ),
                    _createTitle(_trackProvider.getTrackDetails()!),
                    TrackStats(
                        trackDetailsModel: _trackProvider.getTrackDetails()!),
                    PercentageIndicatorWidget(
                      trackAudioFeaturesModel:
                          _trackProvider.getTrackAudioFeatures()!,
                      popularity: _trackProvider.getTrackDetails()!.popularity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
