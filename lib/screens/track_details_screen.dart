import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/models/track_audio_features_model.dart';
import 'package:spotify_helper/models/track_details_model.dart';
import 'package:spotify_helper/providers/tracks_provider.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';
import 'package:spotify_helper/widgets/track_stats/percentage_indicator_widget.dart';

//On Launch call API from provider and gather data to be injected into page
//This might need to be a stateful widget - and use the components as STL

class TrackDetailPage extends StatefulWidget {
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

  //late TrackDetailsModel _trackDetailsModel;
  //late TrackAudioFeaturesModel _trackAudioFeaturesModel;

  Future<void> _getTrackDetails(String trackId) async {
    await _trackProvider.getTrackById(trackId: trackId);
    await _trackProvider.getAudioFeaturesByTrackId(trackId: trackId);
    //_trackAudioFeaturesModel = await Provider.of<TrackProvider>(context, listen: false)
  }

  //TODO include the track_stats widget -> create a builder / A Container Widget

  @override
  Widget build(BuildContext context) {
    final trackIdArgs = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      //backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      backgroundColor: const Color.fromRGBO(128, 161, 212, 1),
      body: FutureBuilder(
        future: _getTrackDetails(trackIdArgs),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const CircularProgressIndicator()
            : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: MyNetworkImage(
                        imageUrl: _trackProvider
                            .getTrackDetails()!
                            .album
                            .albumImageUrl),
                  ),
                ),
                Text(_trackProvider.getTrackDetails()!.trackName),
                PercentageIndicatorWidget(
                  trackAudioFeaturesModel:
                      _trackProvider.getTrackAudioFeatures()!,
                ),
              ]),
      ),
    );
  }
}
