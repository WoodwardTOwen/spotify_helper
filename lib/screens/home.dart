import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spotify_helper/screens/playlist_items_screen.dart';
import 'package:spotify_helper/screens/playlists_screen.dart';
import 'package:spotify_helper/screens/search_all_playlists_screen.dart';
import 'package:spotify_helper/screens/search_for_item.dart';
import 'package:spotify_helper/screens/settings_screen.dart';
import 'package:spotify_helper/screens/user_profile_screen.dart';

// Side note - the bridging for the iOS application is not finished ( up to set -Objc Linker flag) -
// Documentation - https://developer.spotify.com/documentation/ios/quick-start/

class Home extends StatefulWidget {
  static const routeName = '/home-page';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const SearchForItemScreen(),
      const PlaylistsScreen(),
      const UserProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.music_note),
          title: ("Track Finder"),
          activeColorPrimary: const Color.fromRGBO(239, 234, 216, 1),
          inactiveColorPrimary: Colors.white38,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: SearchForItemScreen.routeName,
              routes: {
                SearchAllPlaylistsScreen.routeName: (ctx) =>
                    const SearchAllPlaylistsScreen(),
                SearchForItemScreen.routeName: (ctx) =>
                    const SearchForItemScreen(),
                PlaylistsScreen.routeName: (ctx) => const PlaylistsScreen(),
              })),
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.music_house),
          title: ("Playlists"),
          activeColorPrimary: const Color.fromRGBO(239, 234, 216, 1),
          inactiveColorPrimary: Colors.white38,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: PlaylistsScreen.routeName,
              routes: {
                PlaylistItemsScreen.routeName: (ctx) =>
                    const PlaylistItemsScreen(),
                PlaylistsScreen.routeName: (ctx) => const PlaylistsScreen(),
              })),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: const Color.fromRGBO(239, 234, 216, 1),
        inactiveColorPrimary: Colors.white38,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: UserProfileScreen.routeName,
          routes: {
            UserProfileScreen.routeName: (ctx) => const PlaylistItemsScreen(),
            SettingsScreen.routeName: (ctx) => const SettingsScreen(),
          },
        ),
      ),
    ];
  }
}
