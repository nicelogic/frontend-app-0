import 'api_client.dart';
import 'models/models.dart' as models;

class UserRepository {
  final ApiClient _apiClient;

  UserRepository({required String url, required String token})
      : _apiClient = ApiClient(url: url, token: token);
  void updateToken(final String token) {
    _apiClient.token = token;
  }

  Future<models.User> me() async {
    final user = await _apiClient.me();
    return user;
  }

  Future<models.Users> users({required String idOrName}) async {
    final users = await _apiClient.users(idOrName: idOrName);
    return users;
  }

  Future<models.User> updateUser(
      {required Map<String, String> properties}) async {
    final user = await _apiClient.updateUser(properties: properties);
    return user;
  }

  Future<models.Avatar> preSignedAvatarUrl() async {
    final avatar = await _apiClient.preSignedAvatarUrl();
    return avatar;
  }
}
