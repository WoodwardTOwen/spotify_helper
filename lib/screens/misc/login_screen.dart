import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_helper/providers/spotify_auth.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/util/helper_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isButtonDisable = false;

  void _setButtonState() {
    setState(() {
      _isButtonDisable = !_isButtonDisable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Spotify Helper',
                style: Theme.of(context).textTheme.headline3,
                overflow: TextOverflow.ellipsis,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isButtonDisable
                  ? null
                  : () async {
                      _setButtonState();
                      try {
                        await Provider.of<SpotifyAuth>(context, listen: false)
                            .retrieveSpotifyAuthenticationToken();
                      } on PlatformException catch (e) {
                        HelperMethods.createGenericErrorMessage(context,
                            stringContent: e.message);

                        _setButtonState();
                      }
                    },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
