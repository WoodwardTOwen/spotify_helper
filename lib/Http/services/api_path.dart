class ApiPath {
  static const baseUrl = "https://api.spotify.com";
  //https://developer.spotify.com/documentation/general/guides/authorization/scopes/
  static final List<String> _scopes = [
    'user-read-private',
    'user-read-email',
    'user-top-read',
    'playlist-read-private',
    'user-modify-playback-state',
    'user-read-playback-state',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-modify-private',
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
      "$baseUrl/v1/search?q=$searchedTrack&type=track";

  static String searchForArtist({required String searchedArtist}) =>
      "$baseUrl/v1/search?q=$searchedArtist&type=artist";

  //Playlists
  static String getListOfPlaylists({required int offset, required int limit}) =>
      '$baseUrl/v1/me/playlists?limit=$limit&offset=$offset';

  static String reRouteToPlaylistInApp(String playlistId) {
    return 'spotify:playlist:$playlistId';
  }

  //Post Request
  static Map<String, Object> createUriForSpotify(String trackID,
      {int position = -1}) {
    if (position != 1) {
      return {
        "uris": ["spotify:track:$trackID"],
      };
    } else {
      return {
        "uris": ["spotify:track:$trackID"],
        "position": position,
      };
    }
  }

  //Artists
  static String getArtistById({required String artistId}) =>
      "$baseUrl/v1/artists/$artistId";

  //Recommendations API
  static String getRecommendations(
          {required String trackId,
          required String artistId,
          required String artistGenre,
          int limit = 5}) =>
      "$baseUrl/v1/recommendations?seed_artists=$artistId&seed_genres=$artistGenre&seed_tracks=$trackId&limit=$limit";

  //Tracks
  static String getListOfTracksByLimitAndOffset({
    required int offset,
    required int limit,
    required String playlistId,
  }) =>
      "$baseUrl/v1/playlists/$playlistId/tracks?limit=$limit&offset=$offset";

  static String postNewTracktoPlaylist({required String playlistID}) =>
      "$baseUrl/v1/playlists/$playlistID/tracks";

  static String getTrackById({required String trackId}) =>
      "$baseUrl/v1/tracks/$trackId";

  static String getMultipleTracksById({required String trackIds}) =>
      "$baseUrl/v1/tracks?ids=$trackIds";

  static String getAudioFeaturesById({required String trackId}) =>
      "$baseUrl/v1/audio-features/$trackId";

  static String reRouteToTrackInApp(String trackId) {
    return 'spotify:album:$trackId';
  }

  //Top User Items
  static String getUserTopItems({required String filter, required int limit}) =>
      "$baseUrl/v1/me/top/$filter?limit=$limit";

  static String artistFilter = "artists";
  static String trackFilter = "tracks";

  //Playback
  static String createPlayback = "$baseUrl/v1/me/player/play";

  //Authorization
  static String requestToken = '$baseUrl/api/token';
}
