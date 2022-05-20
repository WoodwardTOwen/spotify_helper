import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/widgets/user_stats/track_tile.dart';
import 'package:spotify_helper/widgets/user_stats/user_stat_header.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user-profile-screen';

  const UserProfileScreen({Key? key}) : super(key: key);

  Future<void> _fetchAndSet(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false)
        .newFetchUsersTopItems();
  }

  Widget _buildTrackHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTrackList(String timeRange) {
    return Consumer<UserProvider>(
      builder: (ctx, data, _) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: ((ctx, index) => TrackTile(
              trackItem: data.getUserTopTracksMap[timeRange]![index],
              indexValue: index + 1,
            )),
        itemCount: data.getUserTopTracksMap[timeRange]!.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: FutureBuilder(
        future: _fetchAndSet(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const UserStatHeader(),
                          _buildTrackHeader(
                            "Top Tracks (Past 4 Weeks)",
                          ),
                          _buildTrackList('short_term'),
                          _buildTrackHeader(
                            "Top Tracks (Past 6 Months)",
                          ),
                          _buildTrackList('medium_term'),
                          _buildTrackHeader(
                            "Top Tracks (All-Time)",
                          ),
                          _buildTrackList('long_term'),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
