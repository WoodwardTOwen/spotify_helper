import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../misc/network_image.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 43.0,
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: MyNetworkImage(imageUrl: user.userImageUrl)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(left: 100),
              child: Text(
                user.displayName,
                style: Theme.of(context).textTheme.headline5,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight +
                const Alignment(
                  0,
                  0.4,
                ),
            child: Text(
              user.email,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
