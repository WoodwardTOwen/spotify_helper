class AuthToken {
  final String _accessToken;
  final DateTime _expiryTime;

  static String accessTokenKey = 'storify-access-token';

  AuthToken({required String accessToken, required DateTime expiryTime})
      : _accessToken = accessToken,
        _expiryTime = expiryTime;

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'],
      expiryTime: DateTime.parse(json['expiry_time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': _accessToken,
        'expiry_time': _expiryTime.toIso8601String(),
      };

  String get getAccessToken => _accessToken;

  bool get isDateValid => _expiryTime.isAfter(DateTime.now());
}
