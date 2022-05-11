import 'package:dio/dio.dart';
import 'package:spotify_helper/models/track_model.dart';
import 'package:spotify_helper/providers/user_provider.dart';
import '../../util/dio_util.dart';
import '../services/api_path.dart';
import 'interface/IUserRepository.dart';

class UserRepository implements IUserRepository {
  final client = DioUtil().getClient;

  @override
  Future<Response<dynamic>> getCurrentlyLoggedInUserDetails() async {
    return await client.get(ApiPath.getCurrentUser);
  }

  @override
  Future<List<TrackModel>> getUsersTopItems(
      {int limit = 5,
      int offset = 0,
      String timeFrame = UserProvider.mediumTerm}) async {
    final response = await client.get(ApiPath.getUserTop5Tracks(
        offset: offset, limit: limit, timeFrame: timeFrame));

    final list = response.data['items']
        .map((item) => TrackModel.fromJson(item))
        .toList();

    return List<TrackModel>.from(list);
  }
}
