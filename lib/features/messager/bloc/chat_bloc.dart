import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/model/conversation_model.dart';
import 'package:fardinexpress/features/messager/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepository = ChatRepository();
  List<ChatUserModel> users = [];
  List<ConversationModel> conversations = [];
  List<ChatUserModel> contacts = [];
  int page = 1;
  final int rowPerPage = 20;
  ChatBloc() : super(ChatInitial()) {
    on<GetUsersStart>((event, emit) async {
      emit(GettingUsers());
      try {
        users = await chatRepository.getUsers(
            fromEmail: event.formEmail, toEmail: event.toEmail);
        emit(GotUsers(users: users));
      } catch (e) {
        emit(ErrorGetUsers(error: e.toString()));
      }
    });

    on<GetConversationStart>((event, emit) async {
      emit(GettingConversations());
      try {
        page = 1;
        conversations = await chatRepository.getConversations(
            fromEmail: event.formEmail,
            toEmail: event.toEmail,
            page: page,
            rowPerPage: rowPerPage);
        page++;
        emit(GotConversations(conversations: conversations));
      } catch (e) {
        emit(ErrorGetConversations(error: e.toString()));
      }
    });

    on<LoadMoreConversationStart>(
      (event, emit) async {
        emit(LoadingMoreConversations());
        try {
          List<ConversationModel> temp = await chatRepository.getConversations(
              fromEmail: event.formEmail,
              toEmail: event.toEmail,
              page: page,
              rowPerPage: rowPerPage);
          conversations.addAll(temp);
          page++;
          if (temp.length < rowPerPage) {
            emit(EndOfLoadMoreConversation());
          } else {
            emit(LoadedMoreConversations(conversations: conversations));
          }
        } catch (e) {
          emit(ErrorLoadMoreConversations(error: e.toString()));
        }
      },
    );

    on<SendMessageStart>((event, emit) async {
      emit(SendingMessage());
      try {
        final channelId = await chatRepository.sendMessage(
            fromEmail: event.fromEmail,
            toEmail: event.toEmail,
            message: event.message,
            attachment: event.attachment);
        emit(SentMessage(channelId: channelId));
      } catch (e) {
        emit(ErrorSendMessage(error: e.toString()));
      }
    });
  }
}
