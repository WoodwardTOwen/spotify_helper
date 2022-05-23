class FollowersModel {
  final String href;
  final int followerTotal;

  FollowersModel({this.href = "", required this.followerTotal});

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
      followerTotal: json['total'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total': followerTotal,
      };
}
