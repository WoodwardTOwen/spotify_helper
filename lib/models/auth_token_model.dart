class AuthToken {
  final String _accessToken;
  final String _refreshToken; //TODO :To Be Implemented:
  final DateTime _expiryTime;

  static String accessTokenKey = 'storify-access-token';
  static String refreshTokenKey = 'storify-refresh-token';

  AuthToken(
      {required String accessToken,
      String refreshToken = "REFRESH_PLACEHOLDER",
      required DateTime expiryTime})
      : _accessToken = accessToken,
        _refreshToken = refreshToken,
        _expiryTime = expiryTime;

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiryTime: DateTime.parse(json['expiry_time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': _accessToken,
        'refresh_token': _refreshToken,
        'expiry_time': _expiryTime.toIso8601String(),
      };

  String get getAccessToken => _accessToken;

  String get getRefreshToken => _refreshToken;

  bool get isDateValid => _expiryTime.isAfter(DateTime.now());
}
