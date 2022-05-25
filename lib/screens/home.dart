import 'package:flutter/material.dart';

// Side note - the bridging for the iOS application is not finished ( up to set -Objc Linker flag) -
// Documentation - https://developer.spotify.com/documentation/ios/quick-start/

class Home extends StatelessWidget {
  static const routeName = '/home-page';

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
