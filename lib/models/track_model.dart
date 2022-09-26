import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../util/helper_methods.dart';

class TrackModel extends Equatable {
  final String trackId;
  final String trackName;
  final String
      artist; //Soon to have its own model - for now keep it simple as a basic String
  final String albumImageUrl;

  const TrackModel(
      {required this.trackId,
      required this.trackName,
      this.artist = "",
      this.albumImageUrl = ""});

  factory TrackModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TrackModel(
          //This was used to avoid an issue in regards to null data being returned occassionally
          trackId: "",
          trackName: "",
          artist: "",
          albumImageUrl: "");
    }
    return TrackModel(
      trackId: json['id'] ?? "",
      trackName: json['name'] ?? "",
      artist: HelperMethods.concatingArtists(json['artists']),
      albumImageUrl: json['album']['images'][0]['url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'trackId': trackId,
        'trackName': trackName,
        'artist': artist,
        'albumImageUrl': albumImageUrl,
      };

  @override
  List<Object?> get props => [
        trackId,
        trackName,
        artist,
        albumImageUrl,
      ];
}
