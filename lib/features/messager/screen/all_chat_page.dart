import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/account/model/account_model.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/messager/bloc/chat_bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/screen/messager_page.dart';
import 'package:fardinexpress/utils/component/widget/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);
  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  late ChatBloc _chatBloc;
  // late ProfileBloc _accountBloc;
  AccountController accountCtr =
      Get.put(AccountController(), tag: "chatAccount");

  final ChatBloc contactBloc = ChatBloc();

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final List<String> _readMessageIds = [];
  // AccountModel? profileModel;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();
    // _accountBloc = ProfileBloc();
    // _accountBloc.add(GetProfileStarted());

    _loadReadMessages();
  }

  bool isLogin = false;

  Future<void> _loadReadMessages() async {
    final readMessages = await _secureStorage.read(key: 'read_messages') ?? '';
    if (readMessages.isNotEmpty) {
      setState(() {
        _readMessageIds.addAll(readMessages.split(','));
      });
    }
  }

  Future<void> _markAsRead(String messageId) async {
    if (!_readMessageIds.contains(messageId)) {
      setState(() {
        _readMessageIds.add(messageId);
      });
      await _secureStorage.write(
        key: 'read_messages',
        value: _readMessageIds.join(','),
      );
    }
  }

  @override
  void dispose() {
    _chatBloc.close();
    // _accountBloc.close();
    super.dispose();
  }

  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        // appBar: AppBar(
        //   elevation: 1,
        //   centerTitle: true,
        //   // shadowColor: Colors.grey.shade50,
        //   // iconTheme: IconThemeData(color: Colors.white),
        //   title: Text('Message',
        //       style: TextStyle(
        //           color: Colors.black,
        //           fontSize: 20,
        //           fontWeight: FontWeight.w500)),
        // ),
        // body:
        BlocBuilder<AuthenticationBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // _accountBloc.add(GetProfileStarted());
          // return BlocBuilder(
          //   bloc: _accountBloc,
          //   builder: (context, state) {
          //     if (state is FetchedProfile) {
          //       profileModel = state.profileModel;
          //       _chatBloc.add(GetUsersStart(formEmail: profileModel!.phone!));
          //       return _buildMainContent(profileModel);
          //     }
          //     return _buildMainContent(profileModel);
          //   },
          // );
          return Obx(() {
            if (accountCtr.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              _chatBloc
                  .add(GetUsersStart(formEmail: accountCtr.accountInfo.phone));
              return _buildMainContent(accountCtr.accountInfo);
            }
          });
        }
        return loginButton(context: context);
      },
    );
    // );
  }

  List<ChatUserModel> _cachedUsers = [];

  Widget _buildMainContent(AccountModel userModel) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      physics: const BouncingScrollPhysics(),
      onRefresh: () => _chatBloc.add(GetUsersStart(formEmail: userModel.phone)),
      child: BlocConsumer(
        bloc: _chatBloc,
        listener: (context, chatState) {
          if (chatState is GotUsers) {
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, chatState) {
          if (chatState is ErrorGetUsers) {
            return _buildEmptyState();
          }
          if (chatState is GotUsers) {
            if (chatState.users.isEmpty) {
              return _buildEmptyState();
            }
            if (chatState.users.isNotEmpty) {
              _cachedUsers = chatState.users;
            }
          }
          if (_cachedUsers.isNotEmpty) {
            return _buildChatList(_cachedUsers);
          }
          return _buildLoadingIndicator();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forum_outlined,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "No Conversations Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildChatList(List<ChatUserModel> users) {
    final updatedUsers = users.map((user) {
      final isRead = user.isRead ||
          (user.lastMessage != null &&
              _readMessageIds.contains(user.messageId!));
      return user.copyWith(isRead: isRead);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        // _buildStoriesSection(users),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "All Conversations",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final user = updatedUsers[index];
              final lastMessage = user.lastMessage ?? "Start a conversation";
              final lastMessageTime = user.time ?? "";
              return _buildChatItem(
                user: user,
                lastMessage: lastMessage,
                time: lastMessageTime,
              );
            },
          ),
        )
      ],
    );
  }

  String _buildAttachmentMessage(ChatUserModel user) {
    final isCurrentUser = user.id != user.fromId;
    final count = user.attachments.length;

    final firstType = user.attachments.last!.type;
    final fileName = user.attachments.last!.name;

    String typeLabel;
    if (firstType.contains("image")) {
      typeLabel = "photo";
    } else if (firstType.contains("video") ||
        (firstType.contains("application/octet-stream") &&
            (fileName.contains("temp") || fileName.contains("mp4")))) {
      typeLabel = "video";
    } else if (firstType.contains("audio") || fileName.contains("m4a")) {
      typeLabel = "voice message";
    } else if (firstType.contains("application")) {
      typeLabel = "attachment";
    } else {
      typeLabel = "file";
    }

    if (count == 1) {
      final article =
          (typeLabel.startsWith(RegExp(r'[aeiouAEIOU]'))) ? "an" : "a";
      return isCurrentUser
          ? "You sent $article $typeLabel"
          : "${user.name.trim()} sent $article $typeLabel";
    } else {
      final pluralLabel = typeLabel.endsWith('s') ? typeLabel : '${typeLabel}s';
      return isCurrentUser
          ? "You sent $count $pluralLabel"
          : "${user.name.trim()} sent $count $pluralLabel";
    }
  }

  Widget _buildChatItem({
    required ChatUserModel user,
    required String lastMessage,
    required String time,
  }) {
    final isRead = user.isRead;
    return InkWell(
      onTap: () {
        openChat(user);
      },
      onLongPress: () {
        // _showChatOptions(user);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(user.image),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Text(
                        _formatTime(DateTime.parse(time)),
                        style: (user.id == user.fromId)
                            ? TextStyle(
                                color: isRead
                                    ? Colors.grey.shade600
                                    : Colors.black,
                                fontSize: 12,
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              )
                            : TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (user.id != user.fromId)
                        Text(
                          lastMessage.isNotEmpty ? "You: " : "",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          lastMessage.isNotEmpty
                              ? parseHtmlString(lastMessage)
                              : _buildAttachmentMessage(user),
                          style: (user.id == user.fromId)
                              ? TextStyle(
                                  color: isRead
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                )
                              : TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isRead && user.id == user.fromId)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openChat(ChatUserModel user) {
    if (!user.isRead && user.messageId != null) {
      _markAsRead(user.messageId!);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessengerPage(
                  userModel: accountCtr.accountInfo,
                  user: user,
                  channelId: user.channelId!,
                )))
      ..then((value) {
        if (value != null) {
          _markAsRead(value);
        }
        _chatBloc.add(GetUsersStart(formEmail: accountCtr.accountInfo.phone));
      });
    ;
  }

  void _showChatOptions(ChatUserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete conversation"),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(user);
                },
              ),
              ListTile(
                leading: Icon(Icons.archive),
                title: Text("Archive chat"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications_off),
                title: Text("Mute notifications"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(ChatUserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete conversation?"),
          content: Text("This will permanently delete this chat history."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: ChatSearchDelegate(
        _chatBloc.state is GotUsers ? (_chatBloc.state as GotUsers).users : [],
        onUserSelected: openChat,
      ),
    );
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(time);
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}

class ChatSearchDelegate extends SearchDelegate {
  final List<ChatUserModel> users;
  final Function(ChatUserModel) onUserSelected;

  ChatSearchDelegate(this.users, {required this.onUserSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? users
        : users
            .where(
                (user) => user.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final user = results[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
          title: Text(user.name),
          onTap: () {
            close(context, null);
            onUserSelected(user);
          },
        );
      },
    );
  }
}
