import 'package:spotify_helper/models/track_model.dart';

import '../util/helper_methods.dart';
import 'album_model.dart';

class TrackDetailsModel extends TrackModel {
  //TODO Can create an album object to make the object even leaner

  final int popularity;
  final String trackSpotifyUri;
  final AlbumModel album;

  const TrackDetailsModel(
      {required trackId,
      required trackName,
      required this.album,
      required trackArtist,
      required this.popularity,
      required this.trackSpotifyUri})
      : super(
          trackId: trackId,
          artist: trackArtist,
          trackName: trackName,
        );

  //TODO Need to add the null excception Protection

  factory TrackDetailsModel.fromJson(Map<String, dynamic> json) {
    return TrackDetailsModel(
      trackId: json['id'] ?? "",
      trackName: json['name'] ?? "",
      trackArtist: HelperMethods.concatingArtists(json['artists']),
      album: AlbumModel.fromJson(json['album']),
      popularity: json['popularity'],
      trackSpotifyUri: json['uri'],
    );
  }

  //TODO

  @override
  List<Object?> get props => [];
}
