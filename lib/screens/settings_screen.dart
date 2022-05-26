import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_auth.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              bottom: 10,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async =>
                      Provider.of<SpotifyAuth>(context, listen: false)
                          .attemptLogout()
                          .then(
                    (value) {
                      Provider.of<UserProvider>(context, listen: false)
                          .removeCurrentUser();
                    },
                  ),
                  child: const Text("Sign Out"),
                ),
              ),
            )
          ],
        ));
  }
}
