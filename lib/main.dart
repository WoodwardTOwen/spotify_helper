import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_helper/Http/bloc/playlist/playlist_bloc_bloc.dart';
import 'package:spotify_helper/providers/playlist_finder_provider.dart';

import 'package:spotify_helper/providers/spotify_auth.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import 'package:spotify_helper/providers/user_stats_provider.dart';
import 'app.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistBloc>(create: (ctx) {
          return PlaylistBloc()..add(MyPlaylistsFetchedEvent());
        }),
      ],
      child: const SpotifyHelper(),
    ),
  );
}

class SpotifyHelper extends StatelessWidget {
  const SpotifyHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => SpotifyAuth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PlaylistFinderProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserStatsProvider(),
        ),
      ],
      child: const App(),
    );
  }
}
