import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class UserStatContainer extends StatelessWidget {
  const UserStatContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    Widget _buildStatItem(String statName, statResult) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(statName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ))),
          Align(
              alignment: Alignment.centerRight,
              child: Text(statResult,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ))),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStatItem("Based In:", user.country),
          const SizedBox(height: 5),
          _buildStatItem(
              "Follower Count:", user.followers.followerTotal.toString()),
          const SizedBox(
            height: 5,
          ),
          _buildStatItem(
            "Playlist Count:",
            "Future Implementation",
          ),
        ],
      ),
    );
  }
}
