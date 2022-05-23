import 'package:flutter/material.dart';

class PlaylistFinderLoadingScreen extends StatelessWidget {
  final String _trackName;
  const PlaylistFinderLoadingScreen({Key? key, required String trackName})
      : _trackName = trackName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Searching for: $_trackName",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const Text(
            "Please Wait!",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
