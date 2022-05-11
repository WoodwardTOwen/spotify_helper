class ApiPath {
  static const baseUrl = "https://api.spotify.com";
  //https://developer.spotify.com/documentation/general/guides/authorization/scopes/
  static final List<String> _scopes = [
    'user-read-private',
    'user-read-email',
    'user-top-read',
    'playlist-read-private',
    'user-modify-playback-state',
    'user-read-playback-state'
  ];

  static String get scopesString => _scopes.join(',');

  //User
  static const String getCurrentUser = '$baseUrl/v1/me';
  static String getUserById(String userId) => '$baseUrl/v1/users/$userId';

  static String getUserTop5Tracks(
          {required int offset,
          required int limit,
          required String timeFrame}) =>
      '$baseUrl/v1/me/top/tracks?limit=$limit&offset=$offset&time_range=$timeFrame';

  //Search - Could potentially expand the limit on these calls but for now keep it at 10
  static String searchForTrack({required String searchedTrack}) =>
      "https://api.spotify.com/v1/search?q=$searchedTrack&type=track";

  static String searchForArtist({required String searchedArtist}) =>
      "https://api.spotify.com/v1/search?q=$searchedArtist&type=artist";

  //Playlists
  static String getListOfPlaylists({required int offset, required int limit}) =>
      'https://api.spotify.com/v1/me/playlists?limit=$limit&offset=$offset';

  //Tracks
  static String getListOfTracksByLimitAndOffset({
    required int offset,
    required int limit,
    required String playlistId,
  }) =>
      "https://api.spotify.com/v1/playlists/$playlistId/tracks?limit=$limit&offset=$offset";

  //Authorization
  static String requestToken = '$baseUrl/api/token';
}
