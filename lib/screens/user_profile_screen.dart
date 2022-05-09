import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/widgets/user_stats/track_tile.dart';
import 'package:spotify_helper/widgets/user_stats/user_stat_header.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile-screen';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _fetchAndSet() async {
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUsersTopItems();
    }

    Widget _buildTrackHeader(String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 30),
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder(
        future: _fetchAndSet(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Column(
                      children: [
                        const UserStatHeader(),
                        _buildTrackHeader(
                          "Top Tracks",
                        ),
                        Expanded(
                          child: Consumer<UserProvider>(
                            builder: (ctx, data, _) => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: ((ctx, index) => TrackTile(
                                    trackItem: data.getTopTracks[index],
                                    indexValue: index + 1,
                                  )),
                              itemCount: data.getTopTracks.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
