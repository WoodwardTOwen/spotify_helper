import '../../../models/auth_token_model.dart';

abstract class IUserStorageRepository {
  Future<void> writeToStorage(AuthToken authToken);

  Future<bool> hasTokenAvaliable();

  Future<void> attemptDataRemoval();
}
