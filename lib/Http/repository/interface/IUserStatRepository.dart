import '../../../models/track_model.dart';

abstract class IUserStatRepository {
  Future<List<TrackModel>> getUsersTopItems(
      {int limit, int offset, String timeFrame});
}
