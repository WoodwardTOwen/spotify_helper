import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:spotify_helper/screens/genre_filter.screen.dart';
import 'package:spotify_helper/screens/playlists/playlist_items_screen.dart';
import 'package:spotify_helper/screens/playlists/playlists_screen.dart';
import 'package:spotify_helper/screens/queued_songs_screen.dart';
import 'package:spotify_helper/screens/user_profile/settings_screen.dart';
import 'package:spotify_helper/screens/search_playlists/search_all_playlists_screen.dart';
import 'package:spotify_helper/screens/search_playlists/search_for_item.dart';
import 'package:spotify_helper/screens/song_queue_screen.dart';
import 'package:spotify_helper/screens/search_playlists/track_details_screen.dart';
import 'package:spotify_helper/screens/user_profile/user_profile_screen.dart';

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
      PersistentTabController(initialIndex: 2);

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
      const SongQueueScreen(),
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
          icon: const Icon(CupertinoIcons.playpause),
          title: ("Suprise Me"),
          activeColorPrimary: const Color.fromRGBO(239, 234, 216, 1),
          inactiveColorPrimary: Colors.white38,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: SongQueueScreen.routeName,
              routes: {
                SongQueueScreen.routeName: (ctx) => const SongQueueScreen(),
                GenreFilterScreen.routeName: (ctx) => const GenreFilterScreen(),
                QueuedSongsScreen.routeName: (ctx) => const QueuedSongsScreen(),
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
                TrackDetailPage.routeName: (ctx) => const TrackDetailPage()
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
