import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spotify_helper/Http/repository/playlist_repository.dart';
import 'package:collection/collection.dart';
import 'package:spotify_helper/models/playlist_model.dart';

import '../models/track_model.dart';

class PlaylistFinderProvider with ChangeNotifier {
  int playlistCount = 0, offset = 0;
  bool isSearchCancelled = false;
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

  void setSearchIsStopped() {
    isSearchCancelled = true;
  }

  void clearCachedSearchItems() {
    if (_searchedTrackResults.isNotEmpty) {
      _searchedTrackResults.clear();
    }
  }

  //Old search method

  //NEED THE CALL FOR GATHER OF DATA
  Future<void> getPlaylistFromRemote() async {
    _listOfUserPlaylists.addAll(await playlistRepository.getPlaylistInformation(
        limit:
            50)); //Need a way to edit so this is recursive to get every possible result
  }

  Future<bool> postNewTrack(
          {required String trackID, required String playlistID}) async =>
      await playlistRepository.postNewTrackToPlaylist(
          trackID: trackID, playlistID: playlistID);

  Future<void> getSearchResults(String searchedForValue) async {
    clearCachedSearchItems();
    _searchedTrackResults.addAll(
        await playlistRepository.getSearchedTrackResults(searchedForValue));
    notifyListeners();
  }

  ///[isSearchCancelled] is used to stop the search if the user presses the back button
  ///[isFound] is used to stop the search if the search result is found
  ///[fetchAndCompare] is used to fetch the next page of results and monitors the offset and limit for each search

  Future<void> getAllPlaylistsContainingSearchItemId(String searchItemId,
      String searchItemTrack, String searchItemArtist) async {
    if (_playlistThatContainTheTrackId.isNotEmpty) {
      _playlistThatContainTheTrackId.clear();
    }
    isSearchCancelled = false;
    playlistCount = _listOfUserPlaylists.first.numOfTracks;

    await Future.doWhile(() async {
      try {
        if (isSearchCancelled == true) {
          return false;
        }

        var isFound = await fetchAndCompare(
            searchItemId, searchItemTrack, searchItemArtist);

        if (isFound || (playlistCount == 0 && isSearchCancelled != true)) {
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
    setSearchIsStopped();
    _listOfUserPlaylists.clear();
    _playlistThatContainTheTrackId.clear();
    _currentPlaylist = null;
  }
}
