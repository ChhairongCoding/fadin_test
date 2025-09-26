import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fardinexpress/features/account/model/account_model.dart';
import 'package:fardinexpress/features/messager/bloc/chat_bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/model/conversation_model.dart';
import 'package:fardinexpress/features/messager/screen/chat_input_widget.dart';
import 'package:fardinexpress/features/messager/screen/user_detail.dart';
import 'package:fardinexpress/features/messager/screen/widget/pdf_attachment_widget.dart';
import 'package:fardinexpress/features/messager/screen/widget/preview_image.dart';
import 'package:fardinexpress/features/messager/screen/widget/sending_widget.dart';
import 'package:fardinexpress/features/messager/screen/widget/video_attachment_widget.dart';
import 'package:fardinexpress/features/messager/screen/widget/voice_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class MessengerPage extends StatefulWidget {
  final AccountModel userModel;
  final ChatUserModel? user;
  final String? channelId;

  MessengerPage(
      {required this.user, required this.channelId, required this.userModel});

  @override
  MessengerPageState createState() => MessengerPageState();
}

class MessengerPageState extends State<MessengerPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _refreshTimer;

  List<ConversationModel> _cachedConversations = [];
  ChatBloc _chatBloc = ChatBloc();
  String? channel_id;
  static bool sendingMessage = false;
  static bool sendingMedia = false;
  static bool sendingVoice = false;
  static bool sendingAttachment = false;

  List<MultipartFile> sendMedia = [];
  String? sendMessage;
  String? sendAttachment;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool _showScrollToBottomBtn = false;

  @override
  void initState() {
    super.initState();
    if (widget.channelId.toString() != "null") {
      channel_id = widget.channelId!;
    }
    if (channel_id != null) {
      _initializeChat();
    }

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final screenHeight = MediaQuery.of(context).size.height;

    if (_scrollController.offset > screenHeight && !_showScrollToBottomBtn) {
      setState(() => _showScrollToBottomBtn = true);
    } else if (_scrollController.offset <= screenHeight &&
        _showScrollToBottomBtn) {
      setState(() => _showScrollToBottomBtn = false);
    }
  }

  void _initializeChat() {
    _chatBloc.add(GetConversationStart(
        formEmail: widget.userModel.phone, toEmail: widget.user!.phone!));

    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_chatBloc.state is! LoadingMoreConversations &&
          _chatBloc.state is! LoadedMoreConversations &&
          _chatBloc.state is! EndOfLoadMoreConversation) {
        print("refreshing");
        _chatBloc.add(GetConversationStart(
            formEmail: widget.userModel.phone, toEmail: widget.user!.phone!));
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_cachedConversations.isNotEmpty) {
          Navigator.pop(context, _cachedConversations.first.id);
        } else {
          Navigator.pop(context);
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: _showScrollToBottomBtn
            ? Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 3,
                    onPressed: _scrollToBottom,
                    child: Icon(
                      Icons.arrow_downward,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              )
            : null,
        body: Column(
          children: [
            channel_id != null
                ? Expanded(
                    child: BlocConsumer(
                      bloc: _chatBloc,
                      listener: (context, state) {
                        if (state is LoadedMoreConversations) {
                          _refreshController.loadComplete();
                        }
                        if (state is EndOfLoadMoreConversation) {
                          _refreshController.loadNoData();
                        }
                      },
                      builder: (context, state) {
                        if (state is GotConversations) {
                          _cachedConversations = state.conversations;
                        }
                        if (state is LoadedMoreConversations) {
                          _cachedConversations = state.conversations;
                        }
                        if (_cachedConversations.isNotEmpty) {
                          return _buildMessageList(_cachedConversations);
                        }
                        return _buildLoadingState(_chatBloc.state);
                      },
                    ),
                  )
                : _buildEmptyState(),
            ChatInputWidget(
              bloc: _chatBloc,
              fromUser: widget.userModel.phone,
              toUser: widget.user!.phone,
              onSendMessage: (message) {
                setState(() {
                  sendingMessage = true;
                  sendMessage = message;
                });
                _chatBloc.add(
                  SendMessageStart(
                      fromEmail: widget.userModel.phone!,
                      toEmail: widget.user!.phone!,
                      message: message,
                      attachment: null),
                );
              },
              onSendMedia: (media) async {
                setState(() {
                  sendingMedia = true;
                  sendMedia = media;
                });
                _chatBloc.add(
                  SendMessageStart(
                      fromEmail: widget.userModel.phone!,
                      toEmail: widget.user!.phone!,
                      message: "",
                      attachment: media),
                );
              },
              onSendAttachment: (attachment) async {
                setState(() {
                  sendingAttachment = true;
                  sendAttachment = attachment[0].filename;
                });
                _chatBloc.add(
                  SendMessageStart(
                      fromEmail: widget.userModel.phone!,
                      toEmail: widget.user!.phone!,
                      message: "",
                      attachment: attachment),
                );
              },
              onSendVoiceMessage: (voiceMessage) async {
                setState(() {
                  sendingVoice = true;
                });
                _chatBloc.add(
                  SendMessageStart(
                      fromEmail: widget.userModel.phone!,
                      toEmail: widget.user!.phone!,
                      message: "",
                      attachment: voiceMessage),
                );
              },
              updateChannelId: (channelId) {
                setState(() {
                  this.channel_id = channelId;
                });
              },
              scrollToBottom: _scrollToBottom,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.message_outlined,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "No Messages Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Start the conversation by sending your first message",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (_cachedConversations.isNotEmpty) {
            Navigator.pop(context, _cachedConversations.first.id);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Hero(
            tag: 'chat-avatar-${widget.user!.id}',
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(widget.user!.image),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user!.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetailPage(
                          user: widget.user!,
                        )));
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState(ChatState state) {
    if (state is ErrorGetConversations) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8),
              Text(
                "Failed to load messages",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     if (channel_id != null) {
              //       _chatBloc.add(GetConversationStart(
              //           formEmail: widget.userModel.phone,
              //           toEmail: widget.user!.phone!));
              //     }
              //   },
              //   child: Text("Retry"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Theme.of(context).primaryColor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment:
                index.isEven ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(List<ConversationModel> messages) {
    final Map<String, List<ConversationModel>> groupedMessages = {};

    for (final message in messages) {
      final date = _formatMessageDate(DateTime.parse(message.timestamp));
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    final List<MessageListItem> items = [];

    if (sendingVoice) {
      items.insert(
          0, MessageListItem(customWidget: SendingVoiceMessageWidget()));
    }
    if (sendingAttachment) {
      items.insert(
          0,
          MessageListItem(
              customWidget:
                  SendingAttachmentWidget(fileName: sendAttachment!)));
    }
    if (sendingMedia) {
      items.insert(0,
          MessageListItem(customWidget: SendingMediaWidget(media: sendMedia)));
    }
    if (sendingMessage) {
      items.insert(
          0,
          MessageListItem(
              customWidget: SendingMessageWidget(message: sendMessage!)));
    }

    final sortedDates = groupedMessages.keys.toList()
      ..sort((a, b) => _parseDateString(b).compareTo(_parseDateString(a)));

    for (final date in sortedDates) {
      final messagesForDate = groupedMessages[date]!
        ..sort(
          (a, b) => DateTime.parse(b.timestamp)
              .compareTo(DateTime.parse(a.timestamp)),
        );

      for (final msg in messagesForDate) {
        items.add(MessageListItem(isHeader: false, message: msg));
      }

      items.add(MessageListItem(isHeader: true, headerText: date));
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          ChatInputWidgetState.showEmojiKeyboard = false;
          ChatInputWidgetState.showAttachmentOptions = true;
        });
      },
      child: Container(
          color: Colors.transparent,
          child: SmartRefresher(
            controller: _refreshController,
            reverse: true,
            enablePullDown: false,
            enablePullUp: true,
            onLoading: () => _chatBloc.add(LoadMoreConversationStart(
                formEmail: widget.userModel.phone!,
                toEmail: widget.user!.email!)),
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                if (item.customWidget != null) return item.customWidget!;

                if (item.isHeader) {
                  return _buildDateHeader(item.headerText!);
                }

                final isMe = item.message!.from != widget.user!.id;

                if (item.message!.attachments.isEmpty) {
                  return _buildMessageBubble(item.message!, isMe);
                } else {
                  return _buildMessageBubbleWithAttachment(item.message!, isMe);
                }
              },
            ),
          )),
    );
  }

  Widget _buildDateHeader(String date) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDateString(String date) {
    final now = DateTime.now();
    if (date == 'Today') return DateTime(now.year, now.month, now.day);
    if (date == 'Yesterday')
      return DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 1));
    return DateFormat('MMMM d, y').parse(date);
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  Widget _buildMessageBubble(ConversationModel message, bool isMe) {
    final time = DateFormat('h:mm a').format(DateTime.parse(message.timestamp));
    final text = parseHtmlString(message.message);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(widget.user!.image),
              ),
            ),
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft:
                            isMe ? Radius.circular(16) : Radius.circular(0),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.grey.shade800,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            time,
                            style: TextStyle(
                              color:
                                  isMe ? Colors.white70 : Colors.grey.shade500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAttachmentWidget(AttachmentModel attachment, bool isMe,
      String time, Radius topLeftRadius, Radius topRightRadius) {
    final type = attachment.type.toLowerCase();
    final fileName = attachment.name.split('/').last;
    final radius = BorderRadius.only(
      topLeft: isMe ? Radius.circular(16) : topLeftRadius,
      topRight: isMe ? topRightRadius : Radius.circular(16),
      bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
      bottomRight: isMe ? Radius.circular(0) : Radius.circular(16),
    );

    if (type.contains("image")) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImagePreviewScreen(imageUrl: attachment.url),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: CachedNetworkImage(
                  imageUrl: attachment.url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Colors.grey[200],
                    child: Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: buildTimeLabel(time),
            ),
          ],
        ),
      );
    }

    if (type.contains("video") ||
        (type.contains("application/octet-stream") &&
            (fileName.contains("temp") || fileName.contains("mp4")))) {
      return VideoAttachmentWidget(
        url: attachment.url,
        isMe: isMe,
        time: time,
        radius: radius,
      );
    }

    if (type.contains("audio") ||
        fileName.contains("m4a") ||
        fileName.contains("wav")) {
      return VoiceMessageWidget(
        url: attachment.url,
        isMe: isMe,
        time: time,
        radius: radius,
      );
    }

    if (type.contains("pdf")) {
      return PDFAttachmentWidget(
        url: attachment.url,
        name: attachment.name,
        isMe: isMe,
        time: time,
        radius: radius,
      );
    }

    return InkWell(
      onTap: () => launch(attachment.url),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).primaryColor : Colors.grey.shade50,
            borderRadius: radius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insert_drive_file,
                      size: 18, color: isMe ? Colors.white : Colors.black54),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      attachment.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeLabel(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMessageBubbleWithAttachment(
      ConversationModel message, bool isMe) {
    final time = DateFormat('h:mm a').format(DateTime.parse(message.timestamp));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(widget.user!.image),
              ),
            ),
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      ...message.attachments.asMap().entries.map((entry) {
                        final index = entry.key;
                        final isFirst = index == 0;
                        final topRightRadius =
                            isFirst ? Radius.circular(16) : Radius.circular(0);
                        final topLeftRadius =
                            isFirst ? Radius.circular(16) : Radius.circular(0);

                        final attachment = entry.value;

                        return buildAttachmentWidget(attachment, isMe, time,
                            topLeftRadius, topRightRadius);
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    _chatBloc.add(GetConversationStart(
        formEmail: widget.userModel.phone!, toEmail: widget.user!.email!));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String parseHtmlString(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }
}
