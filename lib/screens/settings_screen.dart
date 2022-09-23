import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../providers/spotify_auth.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';

  const SettingsScreen({Key? key}) : super(key: key);

  void _onShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async =>
                  Provider.of<SpotifyAuth>(context, listen: false)
                      .attemptLogout()
                      .then(
                (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .removeCurrentUser();

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SettingsList(
        lightTheme: const SettingsThemeData(
          settingsListBackground: Color.fromRGBO(239, 234, 216, 1),
        ),
        sections: [
          SettingsSection(
              title: const Text(
                "Account",
              ),
              tiles: [
                SettingsTile(
                  title: const Text('Email'),
                  description: Text(user.email),
                ),
              ]),
          SettingsSection(
            title: const Text('About'),
            tiles: [
              SettingsTile(
                title: const Text('Version'),
                description: const Text('Pre-Alpha v1.0.0'),
              ),
              SettingsTile(
                title: const Text('Privacy Policy'),
              ),
              SettingsTile(
                title: const Text('Terms of Service'),
              ),
            ],
          ),
          SettingsSection(title: const Text('Application'), tiles: [
            SettingsTile(
              title: const Text("App Permissions"),
              onPressed: (_) {
                AppSettings.openAppSettings();
              },
            ),
            SettingsTile(
              title: const Text('Refresh Token'),
              description: const Text('Refresh your authentication token!'),
              onPressed: (_) => Provider.of<SpotifyAuth>(context, listen: false)
                  .retrieveSpotifyAuthenticationToken(),
            ),
            SettingsTile(
              title: const Text('Logout'),
              onPressed: (_) async => _onShowDialog(context),
            ),
          ]),
        ],
      ),
    );
  }
}
