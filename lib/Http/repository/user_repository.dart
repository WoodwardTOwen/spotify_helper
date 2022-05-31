import 'package:dio/dio.dart';
import '../../util/dio_util.dart';
import '../services/api_path.dart';
import 'interface/IUserRepository.dart';

class UserRepository implements IUserRepository {
  final client = DioUtil().getClient;

  @override
  Future<Response<dynamic>> getCurrentlyLoggedInUserDetails() async {
    return await client.get(ApiPath.getCurrentUser);
  }
}
