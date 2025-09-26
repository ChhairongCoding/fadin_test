// part of 'chat_bloc.dart';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetUsersStart extends ChatEvent {
  final String formEmail;
  final String? toEmail;
  GetUsersStart({required this.formEmail, this.toEmail});
}

class GetConversationStart extends ChatEvent {
  final String formEmail;
  final String toEmail;
  GetConversationStart({required this.formEmail, required this.toEmail});
}

class LoadMoreConversationStart extends ChatEvent {
  final String formEmail;
  final String toEmail;
  LoadMoreConversationStart({required this.formEmail, required this.toEmail});
}

class SendMessageStart extends ChatEvent {
  final String fromEmail;
  final String toEmail;
  final String message;
  final List<MultipartFile>? attachment;
  SendMessageStart(
      {required this.fromEmail,
      required this.toEmail,
      required this.message,
      required this.attachment});
}

class InitializeContactsStarted extends ChatEvent {}

class FetchContactsStarted extends ChatEvent {}
