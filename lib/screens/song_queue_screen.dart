import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spotify_helper/app.dart';
import 'package:spotify_helper/screens/genre_filter.screen.dart';
import 'package:spotify_helper/widgets/song_queue_widgets/category_widget.dart';

class SongQueueScreen extends StatefulWidget {
  static const routeName = '/song-queue';

  const SongQueueScreen({Key? key}) : super(key: key);

  @override
  State<SongQueueScreen> createState() => _SongQueueState();
}

class _SongQueueState extends State<SongQueueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick a Theme")),
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            child: const CategoryListTile(categoryName: "Workout"),
            onTap: () =>
                pushNewScreen(context, screen: const GenreFilterScreen()),
          );
        },
      ),
    );
  }
}
