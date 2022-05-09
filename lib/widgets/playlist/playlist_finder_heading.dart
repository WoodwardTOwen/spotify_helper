import 'package:flutter/material.dart';
import 'package:spotify_helper/models/track_model.dart';

import '../misc/network_image.dart';

class PlaylistFinderHeading extends StatelessWidget {
  final TrackModel trackModel;
  const PlaylistFinderHeading({Key? key, required TrackModel track})
      : trackModel = track,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 5,
          ),
          child: Card(
              color: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.only(top: 75.0),
              child: SizedBox(
                  height: 150.0,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${trackModel.trackName} by ${trackModel.artist}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ))),
        ),
        Positioned(
          left: .0,
          right: .0,
          top: .0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75.0,
              child: CircleAvatar(
                radius: 70.0,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(70.0),
                    child: MyNetworkImage(
                      imageUrl: trackModel.albumImageUrl,
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
