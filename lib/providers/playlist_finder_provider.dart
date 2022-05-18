import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';
import 'package:collection/collection.dart';
import 'package:spotify_helper/models/playlist_model.dart';

import '../models/track_model.dart';

//TODO Create Error handling for an on back pressed scenario
//TOD NEED TO KILL THE PROCESS AND RESET RESORUCES
//NEED TO CLEAN UP AFTER THE RESOURCES
//https://blog.codemagic.io/flutter-tutorial-app-arhitecture-beginners/
//Need to change process to a stream so i can kill off the process - the loading page can then be removed with a loading spinner instead
//https://stackoverflow.com/questions/17552757/is-there-any-way-to-cancel-a-dart-future

class PlaylistFinderProvider with ChangeNotifier {
  int playlistCount = 0, offset = 0;
  final List<PlaylistModel> _listOfUserPlaylists = [];
  PlaylistRepository playlistRepository = PlaylistRepository();

  PlaylistModel? _currentPlaylist;
  final List<PlaylistModel> _playlistThatContainTheTrackId = [];

  final List<TrackModel> _searchedTrackResults = [];

  List<TrackModel> get getSearchedTrackResults {
    return [..._searchedTrackResults];
  }

  List<PlaylistModel> get getListOfPlaylistsForDesiredTrack {
    return [..._playlistThatContainTheTrackId];
  }

  void clearCachedSearchItems() {
    if (_searchedTrackResults.isNotEmpty) {
      _searchedTrackResults.clear();
    }
  }

  Future<void> getPlaylistFromRemoteAddLocally() async {
    final List<PlaylistModel> _playlistFromRemote =
        await playlistRepository.getPlaylistInformation();

    //Add to DB
  }

  //Old search method

  //NEED THE CALL FOR GATHER OF DATA
  Future<void> getPlaylistFromRemote() async {
    _listOfUserPlaylists.addAll(await playlistRepository.getPlaylistInformation(
        limit:
            50)); //Need a way to edit so this is recursive to get every possible result
  }

  //Double check that the searched term isn't the same as the previous - not point making the extra call
  Future<void> getSearchResults(String searchedForValue) async {
    clearCachedSearchItems();
    _searchedTrackResults.addAll(
        await playlistRepository.getSearchedTrackResults(searchedForValue));
    notifyListeners();
  }

  Future<void> getAllPlaylistsContainingSearchItemId(String searchItemId,
      String searchItemTrack, String searchItemArtist) async {
    if (_playlistThatContainTheTrackId.isNotEmpty) {
      _playlistThatContainTheTrackId.clear();
    }
    playlistCount = _listOfUserPlaylists.first.numOfTracks;

    await Future.doWhile(() async {
      try {
        var isFound = await fetchAndCompare(
            searchItemId, searchItemTrack, searchItemArtist);

        if (isFound || playlistCount == 0) {
          _listOfUserPlaylists.removeAt(0);
          _resetCounters();
          if (_listOfUserPlaylists.isEmpty) {
            notifyListeners();
            return false;
          } else {
            playlistCount = _listOfUserPlaylists.first.numOfTracks;
          }
        }
        return true; //toContinue
      } on Exception {
        rethrow;
      }
    });
  }

  void _resetCounters() {
    playlistCount = 0;
    offset = 0;
  }

  Future<bool> fetchAndCompare(String searchItemId, String searchItemTrack,
      String searchItemArtist) async {
    print("im searching still");
    int limit = playlistCount >= 100 ? 100 : playlistCount;
    _currentPlaylist = _listOfUserPlaylists.elementAt(0);

    List<TrackModel> list = await playlistRepository.getListOfTrackModel(
        searchItemId: _listOfUserPlaylists.first.id,
        offset: offset,
        limit: limit);

    final x = list.firstWhereOrNull((track) =>
        track.trackId == searchItemId ||
        (track.trackName == searchItemTrack &&
            track.artist == searchItemArtist));
    if (x != null) {
      _playlistThatContainTheTrackId.add(_currentPlaylist!);
      return true;
    } else {
      offset = playlistCount >= 100 ? offset += 100 : offset += playlistCount;
      playlistCount = playlistCount >= 100 ? playlistCount - 100 : 0;
      return false;
    }
  }

  void disposeSearch() {
    _listOfUserPlaylists.clear();
    _playlistThatContainTheTrackId.clear();
    _currentPlaylist = null;
  }
}
