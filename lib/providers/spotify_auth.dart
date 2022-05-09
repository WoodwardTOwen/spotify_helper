import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_helper/Http/repository/auth_repository.dart';
import 'package:spotify_helper/Http/repository/user_storage_repository.dart';
import 'package:spotify_helper/Http/services/local_storage/storage_service.dart';
import 'package:spotify_helper/models/auth_token_model.dart';

class SpotifyAuth with ChangeNotifier {
  AuthToken? _authToken;
  AuthRepository authRepository = AuthRepository();
  UserStorageRepository userStorageRepository = UserStorageRepository();

  bool get getIsUserAuthenticated =>
      _authToken != null && _authToken!.isDateValid;

  Future<bool> attemptAutoLogin() async {
    if (_authToken == null) {
      final response =
          await StorageServiceUtil().readSecureData(AuthToken.accessTokenKey);
      _authToken =
          (response == null ? null : AuthToken.fromJson(json.decode(response)));
    }

    if (_authToken == null || !_authToken!.isDateValid) {
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<void> _writeToStorage(String accessToken) async {
    _authToken = AuthToken(
      accessToken: accessToken,
      expiryTime: DateTime.now().add(
        const Duration(hours: 1),
      ),
    );
    userStorageRepository.writeToStorage(_authToken!);
  }

  Future<void> attemptLogout() async {
    final hasData = await userStorageRepository.hasTokenAvaliable();
    if (hasData) {
      await userStorageRepository.attemptDataRemoval();
      _authToken = null;
      notifyListeners();
    }
  }

  Future<void> retrieveSpotifyAuthenticationToken() async {
    try {
      final _spotifyAuthToken = await authRepository.requestSpotifyToken();
      _writeToStorage(_spotifyAuthToken);
    } on PlatformException {
      rethrow;
    }
    notifyListeners();
  }
}
