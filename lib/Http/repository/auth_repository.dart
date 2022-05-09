import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_helper/Http/repository/interface/IAuthRepository.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../services/api_path.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<String> requestSpotifyToken() async {
    return await SpotifySdk.getAuthenticationToken(
        clientId: dotenv.env['CLIENT_ID'].toString(),
        redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
        scope: ApiPath.scopesString);
  }
}
