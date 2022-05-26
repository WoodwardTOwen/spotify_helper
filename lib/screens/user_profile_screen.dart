import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/screens/settings_screen.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/user_header.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/user_stat_container.dart';
import '../widgets/user_stats_widgets/track_tile.dart';

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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 21),
        ),
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
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.settings,
                size: 22,
              ),
              onPressed: () =>
                  pushNewScreen(context, screen: const SettingsScreen()))
        ],
      ),
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
                          const UserHeader(),
                          const UserStatContainer(),
                          _buildTrackHeader("Top Tracks - This Month"),
                          _buildTrackList('short_term'),
                          _buildTrackHeader("Top Tracks - Past 6 Months"),
                          _buildTrackList('medium_term'),
                          _buildTrackHeader("Top Tracks - All Time"),
                          _buildTrackList('long_term'),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
