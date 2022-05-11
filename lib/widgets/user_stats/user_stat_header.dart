import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/widgets/user_stats/user_stat_container.dart';
import '../misc/network_image.dart';

class UserStatHeader extends StatelessWidget {
  const UserStatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.only(top: 75.0),
            child: const SizedBox(
              height: 220.0,
              width: double.infinity,
              child: UserStatContainer(),
            ),
          ),
        ),
        Positioned(
          left: .0,
          right: .0,
          top: .0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75.0,
              child: CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child: MyNetworkImage(
                    imageUrl: user.userImageUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
