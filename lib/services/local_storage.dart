import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = const FlutterSecureStorage();
  Future<void> saveToken({required String? token}) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  Future<void> removeToken() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<void> saveSearchHistory({required String history}) async {
    await storage.write(key: "searchHistory", value: history);
    return;
  }

  Future<String?> getSearchHistory() async {
    return await storage.read(key: 'searchHistory');
  }
}
