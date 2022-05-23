import 'package:dio/dio.dart';
import '../../../models/track_model.dart';

abstract class IUserRepository {
  Future<Response<dynamic>> getCurrentlyLoggedInUserDetails();

  Future<List<TrackModel>> getUsersTopItems(
      {int limit, int offset, String timeFrame});
}
