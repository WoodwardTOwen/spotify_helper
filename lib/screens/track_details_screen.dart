import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/providers/tracks_provider.dart';

//On Launch call API from provider and gather data to be injected into page
//This might need to be a stateful widget - and use the components as STL

class TrackDetailPage extends StatelessWidget {
  const TrackDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackIdArgs = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 234, 216, 1),
      body: Center(
        child: ElevatedButton(
          onPressed: () async =>
              await Provider.of<TrackProvider>(context, listen: false)
                  .getTrackById(trackId: trackIdArgs),
          child: const Text(
            'Track Details Trial',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
