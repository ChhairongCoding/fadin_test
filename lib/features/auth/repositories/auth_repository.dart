import 'package:fardinexpress/services/local_storage.dart';

class AuthRepository {
  final LocalStorage _storage = LocalStorage();
  Future<void> saveToken({required String? token}) async {
    await _storage.saveToken(token: token);
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> removeToken() async {
    return await _storage.removeToken();
  }
}
