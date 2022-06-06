import 'package:equatable/equatable.dart';

import './followers_model.dart';

class UserModel extends Equatable {
  final String userId;
  final String displayName;
  final String email;
  final String uri;
  final FollowersModel followers;
  final String userImageUrl;
  final String userHref;
  final String country;
  final String product;

  const UserModel(
      {required this.userId,
      required this.displayName,
      required this.uri,
      required this.email,
      required this.followers,
      required this.userImageUrl,
      required this.userHref,
      this.country = "N/A",
      this.product = "Free"});

  String get getDisplayName => displayName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'],
      displayName: json['display_name'],
      uri: json['uri'],
      email: json['email'] ?? "",
      followers: FollowersModel(
        followerTotal:
            json['followers'] == null ? 0 : json['followers']['total'],
      ),
      userHref: json['href'],
      userImageUrl: json['images'] == null || json['images'].length == 0
          ? ""
          : json['images'][0]['url'],
      country: json['country'] ?? "N/A",
      product: json['product'] ?? "Free",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userId,
        'display_name': displayName,
        'uri': uri,
        'country': country,
        'followers': {
          'href': followers.href,
          'total': followers.followerTotal,
        },
        'images': [
          {'url': userImageUrl}
        ],
        'href': userHref,
        'free': product,
      };

  @override
  List<Object?> get props => [
        userId,
        displayName,
        uri,
        followers,
        userImageUrl,
        userHref,
        country,
      ];
}
