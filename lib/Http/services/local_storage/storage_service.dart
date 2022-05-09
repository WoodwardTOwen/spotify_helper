import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_helper/models/auth_token_model.dart';
import '../../../models/storage_item.dart';
import 'dart:convert';

//TODO keep in mind - "https://stackoverflow.com/questions/57933021/flutter-how-do-i-delete-fluttersecurestorage-items-during-install-uninstall"

/*
  TODO Keys need changing to (to access the data)
    No longer an access token and refresh token because both are built within the same obj now
*/

class StorageServiceUtil {
  static final StorageServiceUtil _storageServiceUtil =
      StorageServiceUtil._internal();
  late FlutterSecureStorage _flutterSecureStorage;

  factory StorageServiceUtil() {
    return _storageServiceUtil;
  }

  StorageServiceUtil._internal() {
    _flutterSecureStorage = const FlutterSecureStorage();
  }

  Future<void> writeToSecureStorage(StorageItem storageItem) async {
    await _flutterSecureStorage.write(
        key: storageItem.key,
        value: storageItem.value,
        aOptions: _getAndroidOptions());
  }

  //Get the Authentication token from storage
  Future<String?> readSecureData(String key) async {
    var readData = await _flutterSecureStorage.read(
        key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<AuthToken?> readSecureToken(String key) async {
    var readData = await _flutterSecureStorage.read(
        key: key, aOptions: _getAndroidOptions());
    return readData != null ? AuthToken.fromJson(json.decode(readData)) : null;
  }

  Future<void> deleteSecureData(String key) async {
    await _flutterSecureStorage.delete(
        key: key, aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  //TODO iOS Options
}
