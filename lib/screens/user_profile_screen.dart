import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/providers/user_stats_provider.dart';
import 'package:spotify_helper/widgets/misc/generic_header.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/user_stat_container.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/user_stat_track_list.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user-profile-screen';

  const UserProfileScreen({Key? key}) : super(key: key);

  Future<void> _fetchAndSet(BuildContext context) async {
    await Provider.of<UserStatsProvider>(context, listen: false)
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

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
                          GenericHeader(
                            imageUrl: user.userImageUrl,
                            titleText: user.displayName,
                            subtitleText: user.displayName,
                            isUserProfile: true,
                          ),
                          const UserStatContainer(),
                          _buildTrackHeader("Top Tracks - This Month"),
                          const UserStatTrackList(
                            trackKey: UserStatsProvider.shortTerm,
                          ),
                          _buildTrackHeader("Top Tracks - Past 6 Months"),
                          const UserStatTrackList(
                            trackKey: UserStatsProvider.mediumTerm,
                          ),
                          _buildTrackHeader("Top Tracks - All Time"),
                          const UserStatTrackList(
                            trackKey: UserStatsProvider.longTerm,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
