import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/user_stat_repository.dart';
import '../models/track_model.dart';

class UserStatsProvider extends ChangeNotifier {
  static const Map<int, String> _timeRanges = {
    1: shortTerm,
    2: mediumTerm,
    3: longTerm
  };

  static const String shortTerm = 'short_term';
  static const String mediumTerm = 'medium_term';
  static const String longTerm = 'long_term';

  final List<TrackModel> _userTopTracks = [];
  final UserStatRepository _userRepository = UserStatRepository();

  List<TrackModel> get getTopTracks {
    return [..._userTopTracks];
  }

  final Map<String, List<TrackModel>> _userTopTracksMap = {};

  Map<String, List<TrackModel>> get getUserTopTracksMap {
    return {..._userTopTracksMap};
  }

  Future<void> newFetchUsersTopItems() async {
    for (var entry in _timeRanges.values) {
      final response = await _userRepository.getUsersTopItems(timeFrame: entry);
      _userTopTracksMap[entry] = response;
    }
    notifyListeners();
  }

  Future<void> fetchMoreItems({required String key}) async {
    final index = _userTopTracksMap[key]!.length;

    try {
      final response =
          await _userRepository.getUsersTopItems(timeFrame: key, offset: index);

      _userTopTracksMap[key]?.addAll(response);
      notifyListeners();
    } catch (exception) {
      rethrow;
    }
  }

  void removeLast5Items(String key) {
    if (_userTopTracksMap[key]!.isEmpty) {
      return;
    } else {
      _userTopTracksMap[key]!.removeRange(5, 10);
      notifyListeners();
    }
  }
}
