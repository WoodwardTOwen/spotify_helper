import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/track_tile.dart';

import '../providers/tracks_provider.dart';

class QueuedSongsScreen extends StatefulWidget {
  static const routeName = '/queued-songs';

  const QueuedSongsScreen({Key? key}) : super(key: key);

  @override
  State<QueuedSongsScreen> createState() => _QueuedSongsScreenState();
}

class _QueuedSongsScreenState extends State<QueuedSongsScreen> {
  Future<void> _getRecommendations(String queue) async {
    await Provider.of<TrackProvider>(context, listen: false)
        .getRecommendationsForTrackQUEUE(queue);
  }

  @override
  Widget build(BuildContext context) {
    final genreDetails = ModalRoute.of(context)!.settings.arguments as String;
    print(genreDetails);

    return Scaffold(
      body: FutureBuilder(
        future: _getRecommendations(genreDetails),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Consumer<TrackProvider>(
                        builder: (ctx, data, _) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: ((ctx, index) => TrackTile(
                                trackItem: data.queuedSongs[index],
                              )),
                          itemCount: data.filteredSongQueueGenreList.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
