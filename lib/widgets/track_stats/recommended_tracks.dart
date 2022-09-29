import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/tracks_provider.dart';
import '../user_stats_widgets/track_tile.dart';

class RecommendedTracks extends StatefulWidget {
  const RecommendedTracks({Key? key}) : super(key: key);

  @override
  State<RecommendedTracks> createState() => _RecommendedTracksState();
}

class _RecommendedTracksState extends State<RecommendedTracks> {
  late TrackProvider _trackProvider;

  @override
  void initState() {
    _trackProvider = Provider.of<TrackProvider>(context, listen: false);
    super.initState();
  }

  Future<void> onInitRecommendedTracks() async {
    await _trackProvider.getArtistGenresByTrackId(
        artistId: _trackProvider.getTrackDetails()!.artistID[0]);
    await _trackProvider.getRecommendationsForTrack();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onInitRecommendedTracks(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Center(child: CircularProgressIndicator()))
              : Consumer<TrackProvider>(
                  builder: (ctx, data, _) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: ((ctx, index) => TrackTile(
                          trackItem: data.currentRecommendedTracks[index],
                          indexValue: index + 1,
                          isTrailing: true,
                        )),
                    itemCount: data.currentRecommendedTracks.length,
                  ),
                ),
    );
  }
}
