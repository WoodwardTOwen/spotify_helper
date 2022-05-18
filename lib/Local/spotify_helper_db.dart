import 'dart:async';
import 'package:floor/floor.dart';
import 'package:spotify_helper/Local/dao/track_model_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/playlist_model.dart';
import '../models/track_model.dart';

@Database(version: 1, entities: [PlaylistModel, TrackModel])
abstract class SpotifyHelperDatabase extends FloorDatabase {
  TrackModelDao get trackModelDao;
}
