import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/screens/search_for_item.dart';
import 'package:spotify_helper/screens/sync_screen.dart';
import 'package:spotify_helper/screens/user_profile_screen.dart';
import 'package:spotify_helper/util/helper_methods.dart';
import 'package:spotify_helper/widgets/misc/network_image.dart';

import '../models/user_model.dart';
import '../providers/spotify_auth.dart';
import '../providers/user_provider.dart';

class SpotifyHelperDrawer extends StatelessWidget {
  final UserModel _currentUser;

  const SpotifyHelperDrawer({
    Key? key,
    required UserModel user,
  })  : _currentUser = user,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
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
                              child: MyNetworkImage(
                                  imageUrl: _currentUser.userImageUrl)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.only(left: 90),
                        child: Text(
                          _currentUser.displayName,
                          style: Theme.of(context).textTheme.headline4,
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
                        _currentUser.email,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: const Text(
                  'User Profile',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  UserProfileScreen.routeName,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(
                  Icons.radio,
                  color: Colors.black,
                ),
                title: const Text(
                  'Search All Playlists',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap: () => Navigator.of(context)
                    .pushNamed(SearchForItemScreen.routeName),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.black),
                title: const Text(
                  'Sync Test',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap: () =>
                    Navigator.of(context).pushNamed(SyncScreen.routeName),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          const Spacer(),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onTap: () async => Provider.of<SpotifyAuth>(context, listen: false)
                .attemptLogout()
                .then(
              (value) {
                Provider.of<UserProvider>(context, listen: false)
                    .removeCurrentUser();
                HelperMethods.createSnackBarMessage(context,
                    "Successfully Logged Out: ${_currentUser.displayName}");
              },
            ),
          )
        ],
      ),
    );
  }
}
