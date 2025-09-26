import 'package:fardinexpress/features/messager/screen/widget/preview_video.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoAttachmentWidget extends StatefulWidget {
  final String url;
  final bool isMe;
  final String time;
  final BorderRadius radius;

  const VideoAttachmentWidget({
    required this.url,
    required this.isMe,
    required this.time,
    required this.radius,
  });

  @override
  _VideoAttachmentWidgetState createState() => _VideoAttachmentWidgetState();
}

class _VideoAttachmentWidgetState extends State<VideoAttachmentWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: ClipRRect(
            borderRadius: widget.radius,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   if (_videoController.value.isPlaying) {
                      //     _videoController.pause();
                      //     _isPlaying = false;
                      //   } else {
                      //     _videoController.play();
                      //     _isPlaying = true;
                      //   }
                      // });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FullScreenVideoPlayer(videoUrl: widget.url),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                        if (!_isPlaying)
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: buildTimeLabel(widget.time),
        ),
      ],
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
}
