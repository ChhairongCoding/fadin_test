import 'package:fardinexpress/features/messager/model/conversation_model.dart';

class ChatUserModel {
  final String id;
  final String name;
  final String image;
  final String? channelId;
  final String? lastMessage;
  final String? time;
  final String? fromId;
  final String? messageId;
  final bool isRead;
  final String? phone;
  final String? email;
  final String? userType;
  final String? memberSince;
  final List<AttachmentModel?> attachments;

  ChatUserModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.channelId,
      required this.lastMessage,
      required this.time,
      required this.fromId,
      required this.messageId,
      this.isRead = false,
      required this.phone,
      required this.email,
      required this.userType,
      required this.memberSince,
      required this.attachments});

  ChatUserModel copyWith(
      {String? id,
      String? name,
      String? image,
      String? channelId,
      String? lastMessage,
      String? time,
      String? fromId,
      String? messageId,
      bool? isRead,
      String? phone,
      String? email,
      String? userType,
      String? memberSince,
      List<AttachmentModel>? attachments}) {
    return ChatUserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        channelId: channelId ?? this.channelId,
        lastMessage: lastMessage ?? this.lastMessage,
        time: time ?? this.time,
        fromId: fromId ?? this.fromId,
        messageId: messageId ?? this.messageId,
        isRead: isRead ?? this.isRead,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        userType: userType ?? this.userType,
        memberSince: memberSince ?? this.memberSince,
        attachments: attachments ?? this.attachments);
  }

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
      image: json["image"].toString(),
      channelId: json["channel_id"].toString(),
      lastMessage: json["last_message"].toString(),
      time: json["last_date"].toString(),
      fromId: json["last_message_from_id"].toString(),
      messageId: json["last_message_id"].toString(),
      phone: json["phone"] == false
          ? json["email"].toString()
          : json["phone"].toString(),
      email: json["email"].toString(),
      userType: json["x_studio_user_type"].toString(),
      memberSince: json["create_date"].toString(),
      attachments:
          (json['last_attachment'] != null && json['last_attachment'] is List)
              ? (json['last_attachment'] as List<dynamic>)
                  .map((attachment) => AttachmentModel.fromJson(attachment))
                  .toList()
              : [],
    );
  }
}
