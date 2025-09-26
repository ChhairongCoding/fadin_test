import 'package:dio/dio.dart';
import 'package:fardinexpress/features/messager/screen/widget/voice_message_widget.dart';
import 'package:flutter/material.dart';

class SendingMessageWidget extends StatelessWidget {
  final String message;
  const SendingMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(0),
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Sending",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendingMediaWidget extends StatefulWidget {
  final List<MultipartFile> media;

  const SendingMediaWidget({required this.media});

  @override
  State<SendingMediaWidget> createState() => _SendingMediaWidgetState();
}

class _SendingMediaWidgetState extends State<SendingMediaWidget> {
  @override
  Widget build(BuildContext context) {
    final isVideo = widget.media.first.filename!.endsWith('.mp4') ||
            widget.media.first.filename!.endsWith('.temp')
        ? true
        : false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minHeight: MediaQuery.of(context).size.height * 0.4,
            minWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: !isVideo
                      ? Container(
                          color: Colors.black12,
                          child: const Center(
                              child: Icon(
                            Icons.image,
                            color: Colors.white,
                          )),
                        )
                      : Container(
                          color: Colors.black12,
                          child: const Center(
                              child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          )),
                        ),
                ),
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Sending",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendingAttachmentWidget extends StatelessWidget {
  final String fileName;
  const SendingAttachmentWidget({required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ))),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Sending",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendingVoiceMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(child: _buildWaveform(context)),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Sending",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.45;

    return SizedBox(
      width: maxWidth,
      height: 24,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: WaveformPainter(
            barsCount: 25,
            progress: 0.0,
            isPlaying: false,
            isMe: true,
            audioLevel: null,
            maxWidth: MediaQuery.of(context).size.width * 0.45,
          ),
        ),
      ),
    );
  }
}
