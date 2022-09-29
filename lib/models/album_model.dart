import 'package:equatable/equatable.dart';
import 'package:spotify_helper/util/helper_methods.dart';

class AlbumModel extends Equatable {
  final String albumId;
  final String albumName;
  final String artist;
  final String albumReleaseDate;
  final String albumImageUrl;

  const AlbumModel(
      {required this.albumId,
      required this.albumName,
      required this.artist,
      required this.albumReleaseDate,
      required this.albumImageUrl});

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
        albumId: json['id'],
        albumName: json['name'],
        artist: HelperMethods.concatingArtists(json['artists']),
        albumImageUrl: json['images'][0]['url'] ?? "",
        albumReleaseDate: json['release_date']);
  }

  @override
  List<Object?> get props => [
        albumId,
        albumName,
        artist,
        albumReleaseDate,
        albumImageUrl,
      ];
}
