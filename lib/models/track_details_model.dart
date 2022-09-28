import 'package:spotify_helper/models/track_model.dart';
import '../util/helper_methods.dart';
import 'album_model.dart';

class TrackDetailsModel extends TrackModel {
  final int popularity;
  final String trackSpotifyUri;
  final AlbumModel album;

  const TrackDetailsModel(
      {required trackId,
      required trackName,
      required this.album,
      required trackArtist,
      required this.popularity,
      required albumUrl,
      required artistID,
      required this.trackSpotifyUri})
      : super(
          trackId: trackId,
          artist: trackArtist,
          trackName: trackName,
          albumImageUrl: albumUrl,
          artistID: artistID,
        );

  //TODO Need to add the null excception Protection

  factory TrackDetailsModel.fromJson(Map<String, dynamic> json) {
    return TrackDetailsModel(
      trackId: json['id'] ?? "",
      trackName: json['name'] ?? "",
      trackArtist: HelperMethods.concatingArtists(json['artists']),
      artistID: HelperMethods.filterListForArtistId(json['artists']),
      album: AlbumModel.fromJson(json['album']),
      albumUrl: json['album']['images'][0]['url'] ?? "",
      popularity: json['popularity'],
      trackSpotifyUri: json['uri'],
    );
  }

  //TODO
  //TODO
  //TODO

  @override
  List<Object?> get props => [];
}
