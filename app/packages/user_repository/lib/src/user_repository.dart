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
}
