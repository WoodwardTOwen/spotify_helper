import 'package:dio/dio.dart';
import 'package:spotify_helper/Http/repository/auth_repository.dart';
import 'package:spotify_helper/Http/repository/user_storage_repository.dart';
import 'package:spotify_helper/Http/services/local_storage/storage_service.dart';
import '../models/auth_token_model.dart';

class DioUtil {
  static final DioUtil _dioUtil = DioUtil._internal();
  late Dio _dio;

  AuthRepository authRepository = AuthRepository();
  UserStorageRepository userStorageRepository = UserStorageRepository();

  factory DioUtil() {
    return _dioUtil;
  }

  DioUtil._internal() {
    _dio = Dio();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final AuthToken? token = await StorageServiceUtil()
              .readSecureToken(AuthToken.accessTokenKey);
          if (token != null) {
            if (token.getAccessToken.isNotEmpty) {
              final accessToken = token.getAccessToken;
              options.headers['Authorization'] = 'Bearer $accessToken';
              options.contentType = Headers.contentTypeHeader;
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response!.statusCode == 401) {
            await refreshToken();
            handler.resolve(
              await _retry(error.requestOptions, _dio),
            );
          }
        },
      ),
    );
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await authRepository.requestSpotifyToken();
      userStorageRepository.writeToStorage(
        AuthToken(
          accessToken: refreshToken,
          expiryTime: DateTime.now().add(
            const Duration(hours: 1),
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, Dio dio) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Dio get getClient => _dio;

  dispose() {
    _dio.close();
  }
}
