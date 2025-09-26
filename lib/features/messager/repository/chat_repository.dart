import 'package:dio/dio.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/model/conversation_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRepository {
  // final String baseUrl = "https://anakutdigital.com";
  final Dio dio = Dio();

  Future<List<ChatUserModel>> getUsers({
    required String fromEmail,
    required String? toEmail,
  }) async {
    try {
      String url = toEmail != null
          ? "https://anakutdigital.com/api/anakutjob/public/chat/users?from_email=$fromEmail&to_email=$toEmail"
          : "https://anakutdigital.com/api/anakutjob/public/chat/users?from_email=$fromEmail";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final users = (response.data['result'] as List)
            .map((user) => ChatUserModel.fromJson(user))
            .toList();
        return users;
      } else {
        throw response.data['message'];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<ConversationModel>> getConversations({
    required String fromEmail,
    required String toEmail,
    required int page,
    required int rowPerPage,
  }) async {
    try {
      String url =
          "https://anakutdigital.com/api/anakutjob/public/chat/conversation?from_email=$fromEmail&to_email=$toEmail&page=$page&row_per_page=$rowPerPage";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final conversations = (response.data['result'] as List)
            .map((item) => ConversationModel.fromJson(item))
            .toList();
        return conversations;
      } else {
        throw response.data['message'];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> sendMessage({
    required String message,
    required String fromEmail,
    required String toEmail,
    required List<MultipartFile>? attachment,
  }) async {
    try {
      String url = "https://anakutdigital.com/api/anakutjob/public/chat/send";

      final formData = FormData.fromMap({
        'from_email': fromEmail,
        'to_email': toEmail,
        'message': message,
        if (attachment != null) 'attachment': attachment,
      });

      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data["result"]["channel_id"].toString();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
