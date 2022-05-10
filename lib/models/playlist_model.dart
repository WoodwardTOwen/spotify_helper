import 'package:equatable/equatable.dart';
import 'package:spotify_helper/models/user_model.dart';

class PlaylistModel extends Equatable {
  final String name;
  final String id;
  final UserModel owner;
  final bool isPublic;
  final int numOfTracks;
  final String playlistImageUrl;
  final String externalUrl;

  const PlaylistModel({
    required this.name,
    required this.id,
    required this.owner,
    required this.isPublic,
    required this.numOfTracks,
    required this.playlistImageUrl,
    required this.externalUrl,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      name: json['name'],
      id: json['id'],
      owner: UserModel.fromJson(
        json['owner'],
      ),
      isPublic: json['public'],
      numOfTracks: json['tracks']['total'],
      playlistImageUrl:
          json['images'].length != 0 ? json['images'][0]['url'] : "",
      externalUrl: json['external_urls']['spotify'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'external_url': externalUrl,
        'is_public': isPublic,
        'num_of_tracks': numOfTracks,
        'playlist_image_url': playlistImageUrl,
        'owner': owner.toJson(),
      };

  @override
  List<Object?> get props => [
        name,
        id,
        owner,
        isPublic,
        numOfTracks,
        playlistImageUrl,
        externalUrl,
      ];
}
