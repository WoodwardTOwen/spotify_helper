import 'package:spotify_helper/Http/repository/interface/IUserStatRepository.dart';

import '../../models/track_model.dart';
import '../../providers/user_stats_provider.dart';
import '../../util/dio_util.dart';
import '../services/api_path.dart';

class UserStatRepository implements IUserStatRepository {
  final client = DioUtil().getClient;

  @override
  Future<List<TrackModel>> getUsersTopItems(
      {int limit = 5,
      int offset = 0,
      String timeFrame = UserStatsProvider.mediumTerm}) async {
    final response = await client.get(ApiPath.getUserTop5Tracks(
        offset: offset, limit: limit, timeFrame: timeFrame));

    final list = response.data['items']
        .map((item) => TrackModel.fromJson(item))
        .toList();

    return List<TrackModel>.from(list);
  }
}
