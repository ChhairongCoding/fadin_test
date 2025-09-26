import 'package:flutter/material.dart';

class ConversationModel {
  final String id;
  final String message;
  final String from;
  final String from_name;
  final String timestamp;
  final List<AttachmentModel> attachments;
  ConversationModel({
    required this.id,
    required this.message,
    required this.from,
    required this.from_name,
    required this.timestamp,
    required this.attachments,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'].toString(),
      message: json['message'].toString(),
      from: json['from'].toString(),
      from_name: json['from_name'].toString(),
      timestamp: json['timestamp'].toString(),
      attachments: (json['attachments'] as List<dynamic>)
          .map((attachment) => AttachmentModel.fromJson(attachment))
          .toList(),
    );
  }
}

class AttachmentModel {
  final String id;
  final String name;
  final String type;
  final String url;

  AttachmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      type: json['mimetype'].toString(),
      url: json['url'].toString(),
    );
  }
}

class MessageListItem {
  final bool isHeader;
  final String? headerText;
  final ConversationModel? message;
  final Widget? customWidget;

  MessageListItem({
    this.isHeader = false,
    this.headerText,
    this.message,
    this.customWidget,
  });
}
