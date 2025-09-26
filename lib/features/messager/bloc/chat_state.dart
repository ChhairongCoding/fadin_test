// part of 'chat_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/model/conversation_model.dart';

class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class GettingUsers extends ChatState {}

class GotUsers extends ChatState {
  final List<ChatUserModel> users;
  GotUsers({required this.users});
}

class ErrorGetUsers extends ChatState {
  final String error;
  ErrorGetUsers({required this.error});
}

class GettingConversations extends ChatState {}

class GotConversations extends ChatState {
  final List<ConversationModel> conversations;
  GotConversations({required this.conversations});
}

class ErrorGetConversations extends ChatState {
  final String error;
  ErrorGetConversations({required this.error});
}

class LoadingMoreConversations extends ChatState {}

class LoadedMoreConversations extends ChatState {
  final List<ConversationModel> conversations;
  LoadedMoreConversations({required this.conversations});
}

class ErrorLoadMoreConversations extends ChatState {
  final String error;
  ErrorLoadMoreConversations({required this.error});
}

class EndOfLoadMoreConversation extends ChatState {}

class SendingMessage extends ChatState {}

class SentMessage extends ChatState {
  final String channelId;
  SentMessage({required this.channelId});
}

class ErrorSendMessage extends ChatState {
  final String error;
  ErrorSendMessage({required this.error});
}

class InitializingContact extends ChatState {}

class InitializedContact extends ChatState {
  final List<ChatUserModel> users;
  InitializedContact({required this.users});
}

class ErrorInitializeContact extends ChatState {
  final String error;
  ErrorInitializeContact({required this.error});
}

class FetchingContact extends ChatState {}

class FetchedContact extends ChatState {
  final List<ChatUserModel> users;
  FetchedContact({required this.users});
}

class ErrorFetchContact extends ChatState {
  final String error;
  ErrorFetchContact({required this.error});
}

class EndOfContact extends ChatState {}
