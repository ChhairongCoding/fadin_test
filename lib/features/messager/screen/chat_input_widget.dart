import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:fardinexpress/features/messager/bloc/chat_bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/screen/messager_page.dart';
import 'package:fardinexpress/features/messager/screen/widget/custom_camera_widget.dart';
import 'package:fardinexpress/features/messager/screen/widget/media_grid_item.dart';
import 'package:fardinexpress/features/messager/screen/widget/voice_message_sender.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:record/record.dart';
import 'package:http_parser/http_parser.dart';

class ChatInputWidget extends StatefulWidget {
  final String? fromUser;
  final String? toUser;
  final Function(String) onSendMessage;
  final Function(List<MultipartFile>) onSendMedia;
  final Function(List<MultipartFile>) onSendAttachment;
  final Function(List<MultipartFile>) onSendVoiceMessage;
  final ChatBloc bloc;
  final Function(String) updateChannelId;
  final Function() scrollToBottom;

  const ChatInputWidget({
    Key? key,
    required this.fromUser,
    required this.toUser,
    required this.onSendMessage,
    required this.onSendMedia,
    required this.onSendAttachment,
    required this.bloc,
    required this.updateChannelId,
    required this.scrollToBottom,
    required this.onSendVoiceMessage,
  }) : super(key: key);

  @override
  ChatInputWidgetState createState() => ChatInputWidgetState();
}

class ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSendButton = false;
  static bool showAttachmentOptions = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    _initAudioSession();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRecording) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
          _audioLevel = Random().nextDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showSendButton = _messageController.text.trim().isNotEmpty;
      showAttachmentOptions = _messageController.text.trim().isEmpty;
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
    }
  }

  Future<void> pickMediaWithBottomSheet(BuildContext context,
      void Function(List<MultipartFile>) onSendImage) async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth || permission.hasAccess == false) {
      await PhotoManager.openSetting();
      return;
    }

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      onlyAll: true,
    );

    List<AssetEntity> media = [];
    try {
      media = await albums[0].getAssetListPaged(page: 0, size: 100);
    } catch (e) {
      debugPrint("Error fetching assets: $e");
      return;
    }

    final List<AssetEntity> filtered = media.where((asset) {
      final isValidType =
          asset.type == AssetType.image || asset.type == AssetType.video;
      final isNotWebp = !asset.title!.toLowerCase().endsWith('.webp');
      return isValidType && isNotWebp;
    }).toList();

    final selectedIds = ValueNotifier<Set<String>>({});

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Media',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: selectedIds,
                        builder: (_, selected, __) => TextButton(
                          onPressed: () async {
                            final selectedAssets = filtered
                                .where((a) => selected.contains(a.id))
                                .toList();

                            final files = await Future.wait(
                                selectedAssets.map((e) => e.file));

                            final validFiles = files.whereType<File>().toList();

                            final List<MultipartFile> attachments =
                                await Future.wait(validFiles.map(
                              (file) async => await MultipartFile.fromFile(
                                file.path,
                                filename: file.path.split('/').last,
                              ),
                            ));

                            onSendImage(attachments);
                            Navigator.pop(context);
                          },
                          child: Text(
                              'Send${selected.length > 0 ? " (${selected.length})" : ''}',
                              style: const TextStyle(color: Colors.blue)),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (_, index) {
                      final asset = filtered[index];
                      return MediaGridItem(
                          asset: asset, selectedIds: selectedIds);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Future<void> _takePhoto() async {
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     widget.onSendMedia(File(image.path));
  //   }
  // }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final List<MultipartFile> documents = await Future.wait(result.files.map(
        (file) async => await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      ));

      widget.onSendAttachment(documents);
    }
  }

  static bool showEmojiKeyboard = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is SentMessage) {
          _messageController.clear();
          widget.updateChannelId(state.channelId);
          MessengerPageState.sendingMedia = false;
          MessengerPageState.sendingVoice = false;
          MessengerPageState.sendingMessage = false;
          MessengerPageState.sendingAttachment = false;
          widget.bloc.add(GetConversationStart(
              formEmail: widget.fromUser!, toEmail: widget.toUser!));
          widget.scrollToBottom();
        }
        if (state is ErrorSendMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSending = state is SendingMessage;

        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    showAttachmentOptions
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildAttachmentButton(
                                icon: Icons.add_circle,
                                onTap: _pickDocument,
                                tooltip: "",
                              ),
                              _buildAttachmentButton(
                                icon: Icons.camera_alt,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PremiumCameraWidget(
                                              onMediaCaptured:
                                                  (XFile file) async {
                                                final multipartFile =
                                                    await MultipartFile
                                                        .fromFile(
                                                  file.path,
                                                  filename: file.name,
                                                );

                                                widget.onSendMedia(
                                                    [multipartFile]);
                                              },
                                            ))),
                                tooltip: "",
                              ),
                              _buildAttachmentButton(
                                icon: Icons.image,
                                onTap: () => pickMediaWithBottomSheet(
                                    context, widget.onSendMedia),
                                tooltip: "",
                              ),
                            ],
                          )
                        : !_isRecording && _audioPath == null
                            ? _buildAttachmentButton(
                                icon: Icons.arrow_forward_ios_rounded,
                                onTap: () {
                                  setState(() {
                                    showAttachmentOptions = true;
                                  });
                                },
                                tooltip: "",
                              )
                            : Container(),
                    const SizedBox(width: 2),
                    if (!_isRecording && _audioPath == null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  focusNode: _focusNode,
                                  onTap: () => setState(() {
                                    showEmojiKeyboard = false;
                                  }),
                                  enabled: !isSending,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    hintText: "Type a message...",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  maxLines: 10,
                                  minLines: 1,
                                  onSubmitted: (_) => _sendMessage(),
                                  onChanged: (text) {
                                    setState(() {
                                      _showSendButton = text.trim().isNotEmpty;
                                      showAttachmentOptions =
                                          text.trim().isEmpty;
                                    });
                                  },
                                ),
                              ),
                              _buildAttachmentButton(
                                  icon: Icons.emoji_emotions,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      showEmojiKeyboard = !showEmojiKeyboard;
                                    });
                                  },
                                  tooltip: ""),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    isSending
                        ? Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            ),
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _showSendButton
                                ? Material(
                                    shape: const CircleBorder(),
                                    color: Theme.of(context).primaryColor,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: _sendMessage,
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.send_rounded,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : _isRecording || _audioPath != null
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Material(
                                            shape: const CircleBorder(),
                                            color: Colors.red.withOpacity(0.1),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: _isRecording
                                                  ? _stopRecording
                                                  : _cancelRecording,
                                              child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  _isRecording
                                                      ? Icons.stop
                                                      : Icons.delete,
                                                  size: 24,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            height: 40,
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.68,
                                            ),
                                            padding: const EdgeInsets.only(
                                                right: 10, top: 4, bottom: 4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: IntrinsicWidth(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    child:
                                                        _buildRecordingWaveform(
                                                            context),
                                                  ),
                                                  Text(
                                                    _formatDuration(
                                                        _recordingDuration),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Material(
                                            shape: const CircleBorder(),
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () {
                                                _isRecording
                                                    ? _stopRecording().then(
                                                        (_) =>
                                                            _sendVoiceMessage())
                                                    : _sendVoiceMessage();
                                              },
                                              child: const SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  Icons.send_rounded,
                                                  size: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Material(
                                        shape: const CircleBorder(),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: _startRecording,
                                          onLongPress: _startRecording,
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Icon(Icons.mic_rounded,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                          )
                  ],
                ),
                if (showEmojiKeyboard) ...[
                  SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        _messageController.text += emoji.emoji;
                        _messageController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _messageController.text.length),
                        );
                      },
                      onBackspacePressed: () {
                        if (_messageController.text.isNotEmpty) {
                          _messageController.text = _messageController.text
                              .substring(0, _messageController.text.length - 1);
                        }
                      },
                      config: Config(
                        height: MediaQuery.of(context).size.height * 0.3,
                        emojiTextStyle: const TextStyle(fontSize: 22),
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 32.0,
                          verticalSpacing: 8,
                          horizontalSpacing: 8,
                          backgroundColor: Colors.white,
                        ),
                        categoryViewConfig: CategoryViewConfig(
                          backgroundColor: const Color(0xFFF2F2F2),
                          iconColor: Colors.grey,
                          iconColorSelected: Theme.of(context).primaryColor,
                          indicatorColor: Theme.of(context).primaryColor,
                          dividerColor: Colors.grey[300],
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(
                          backgroundColor: const Color(0xFFF2F2F2),
                          showBackspaceButton: false,
                          showSearchViewButton: false,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Duration _recordingDuration = Duration.zero;
  double? _audioLevel;
  String? _audioPath;
  final AudioRecorder _audioRecorder = AudioRecorder();

  Widget _buildRecordingWaveform(BuildContext context) {
    final double availableWidth = MediaQuery.of(context).size.width * 0.54;
    const double barWidth = 3.0;
    const double spacing = 2.0;

    final int calculatedBarsCount =
        ((availableWidth) / (barWidth + spacing)).floor();
    final int barsCount = calculatedBarsCount.clamp(15, 35);

    return SizedBox(
      width: availableWidth,
      height: 24,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: RecordingWaveformPainter(
            barsCount: barsCount,
            barWidth: barWidth,
            spacing: spacing,
            audioLevel: _audioLevel,
            isRecording: _isRecording,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _audioPath = filePath;
          _recordingDuration = Duration.zero;
          showAttachmentOptions = false;
        });

        _startRecordingTimer();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  void _startRecordingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
        _startRecordingTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) {
          _audioPath = path;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    }
  }

  Future<void> _sendVoiceMessage() async {
    if (_audioPath == null) return;

    final audioFile = File(_audioPath!);
    if (!await audioFile.exists()) return;

    widget.onSendVoiceMessage([
      MultipartFile.fromBytes(await audioFile.readAsBytes(),
          filename: audioFile.path.split('/').last,
          contentType: MediaType('audio', 'm4a')),
    ]);

    setState(() {
      _audioPath = null;
      _recordingDuration = Duration.zero;
      showAttachmentOptions = true;
    });
  }

  Future<void> _cancelRecording() async {
    if (_isRecording) {
      await _audioRecorder.stop();
    }
    if (_audioPath != null) {
      final file = File(_audioPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    setState(() {
      _isRecording = false;
      _audioPath = null;
      _recordingDuration = Duration.zero;
      showAttachmentOptions = true;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
