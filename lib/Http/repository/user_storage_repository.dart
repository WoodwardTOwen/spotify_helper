import 'dart:convert';

import 'package:spotify_helper/Http/services/local_storage/storage_service.dart';

import '../../models/auth_token_model.dart';
import '../../models/storage_item.dart';
import 'interface/IUserStorageRepository.dart';

class UserStorageRepository implements IUserStorageRepository {
  final flutterSecureStorage = StorageServiceUtil();

  @override
  Future<void> writeToStorage(AuthToken authToken) async {
    await StorageServiceUtil().writeToSecureStorage(
      StorageItem(
        AuthToken.accessTokenKey,
        jsonEncode(
          authToken.toJson(),
        ),
      ),
    );
  }

  @override
  Future<bool> hasTokenAvaliable() async {
    final storedData =
        await StorageServiceUtil().readSecureData(AuthToken.accessTokenKey);
    if (storedData != null && storedData.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<void> attemptDataRemoval() async =>
      await StorageServiceUtil().deleteSecureData(AuthToken.accessTokenKey);
}
