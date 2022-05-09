import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/user_repository.dart';

import '../models/track_model.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<TrackModel> _userTopTracks = [];
  final UserRepository _userRepository = UserRepository();

  List<TrackModel> get getTopTracks {
    return [..._userTopTracks];
  }
  //Double check the fetching stuff because it may not be required to have this async function and instead just a simple getter
  //Could just have a fetch at the beginning no matter what because we always need the user data

  UserModel get getUser => _currentUser!;
  //This could be potentially removed and categorised as redudant -> double check over logic when re factoring
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

  Future<void> fetchUsersTopItems() async {
    final response = await _userRepository.getUsersTopItems();
    _userTopTracks = response;
    notifyListeners();
  }
}
