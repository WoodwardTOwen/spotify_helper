import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/user_repository.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  final UserRepository _userRepository = UserRepository();

  UserModel get getUser => _currentUser!;

  Future<UserModel> get getCurrentUser async => await _getCurrentLoggedInUser();

  Future<UserModel> _getCurrentLoggedInUser() async {
    if (_currentUser == null) {
      await fetchCurrentUser();
    }
    return _currentUser!;
  }

  Future<void> fetchCurrentUser() async {
    final response = await _userRepository.getCurrentlyLoggedInUserDetails();
    _currentUser = UserModel.fromJson(response.data);
    notifyListeners();
  }

  void removeCurrentUser() {
    _currentUser = null;
  }
}
