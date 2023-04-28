import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/spotify_auth.dart';
import 'package:spotify_helper/screens/home.dart';
import 'package:spotify_helper/screens/misc/login_screen.dart';
import 'package:spotify_helper/screens/misc/splash_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SpotifyAuth>(
      builder: (ctx, auth, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spotify Helper',
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromRGBO(109, 139, 116, 1),
              secondary: Colors.amber),
          textTheme: const TextTheme(
            headline3: TextStyle(fontSize: 40, color: Colors.white),
            headline4: TextStyle(fontSize: 24, color: Colors.white),
            headline5: TextStyle(fontSize: 16, color: Colors.white),
            headline6: TextStyle(fontSize: 12, color: Colors.white),
            bodyText2: TextStyle(fontSize: 16, color: Colors.white),
            bodyText1: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
        home: auth.getIsUserAuthenticated
            ? const Home()
            : FutureBuilder(
                future: auth.attemptAutoLogin(),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const LoginScreen(),
              ),
      ),
    );
  }
}
