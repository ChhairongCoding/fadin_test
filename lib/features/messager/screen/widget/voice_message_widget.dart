import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceMessageWidget extends StatefulWidget {
  final String url;
  final bool isMe;
  final String time;
  final BorderRadius radius;

  const VoiceMessageWidget({
    required this.url,
    required this.isMe,
    required this.time,
    required this.radius,
  });

  @override
  _VoiceMessageWidgetState createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late AnimationController _waveformController;
  late Animation<double> _waveformAnimation;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();

    _waveformController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _waveformAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _waveformController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
          _isLoading = false;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (_isPlaying) {
            _waveformController.repeat(reverse: true);
          } else {
            _waveformController.stop();
            _waveformController.value = 0.0;
          }
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    // setState(() {
    //   _isLoading = true;
    //   _hasError = false;
    // });

    try {
      if (_position.inMilliseconds > 0) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(UrlSource(widget.url));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLeftAligned = !widget.isMe;

    return IntrinsicWidth(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: widget.isMe
              ? Theme.of(context).primaryColor
              : Colors.grey.shade50,
          borderRadius: widget.radius,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  _buildPlayButton(),
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
                  widget.time,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    if (_isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.isMe ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayback,
      child: AnimatedBuilder(
        animation: _waveformAnimation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  widget.isMe ? Colors.white : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _hasError
                  ? Icons.error_outline
                  : _isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
              size: 16,
              color: widget.isMe
                  ? _hasError
                      ? Colors.red
                      : Theme.of(context).primaryColor
                  : _hasError
                      ? Colors.red
                      : Colors.grey.shade50,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveform(BuildContext context) {
    final double progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    final maxWidth = MediaQuery.of(context).size.width * 0.45;

    return SizedBox(
      width: maxWidth,
      height: 24,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: WaveformPainter(
            barsCount: 25,
            progress: progress,
            isPlaying: _isPlaying,
            isMe: widget.isMe,
            audioLevel: null,
            maxWidth: MediaQuery.of(context).size.width * 0.45,
          ),
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final int barsCount;
  final double progress;
  final bool isPlaying;
  final bool isMe;
  final double? audioLevel;
  final double maxWidth;

  WaveformPainter({
    required this.barsCount,
    required this.progress,
    required this.isPlaying,
    required this.isMe,
    this.audioLevel,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double barWidth = 2.8;
    final double spacing = 2.2;
    final double maxBarHeight = size.height;
    final double now = DateTime.now().millisecondsSinceEpoch.toDouble();

    final double totalBarsWidth = barsCount * barWidth;
    final double totalSpacing = (barsCount - 1) * spacing;
    final double contentWidth = totalBarsWidth + totalSpacing;
    final double startOffset = (size.width - contentWidth) / 2;

    final Color activeColor = isMe ? Colors.white : Colors.black87;
    final Color inactiveColor = isMe
        ? Colors.white.withOpacity(0.35)
        : Colors.black87.withOpacity(0.25);

    for (int i = 0; i < barsCount; i++) {
      final double normalized = i / barsCount;
      final double x = startOffset + i * (barWidth + spacing);

      final bool isActive = !isPlaying || normalized <= progress;

      double animationFactor = isPlaying ? (now / 200) : 0;
      double sineWave1 = 0.5 + 0.5 * sin((normalized * 30) + animationFactor);
      double sineWave2 =
          0.3 + 0.7 * sin((normalized * 15) + animationFactor * 1.3);
      double combinedWave = (sineWave1 + sineWave2) / 2;

      double audioFactor =
          audioLevel != null ? lerpDouble(0.7, 1.3, audioLevel!)! : 1.0;
      double barHeight = maxBarHeight * combinedWave * audioFactor;

      if (!isActive) {
        barHeight *= 0.4;
        paint.color = inactiveColor;
      } else {
        paint.color = activeColor;
        if (!isPlaying) barHeight *= 0.8;
      }

      canvas.save();
      canvas.translate(x + barWidth / 2, maxBarHeight / 2);
      canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: barWidth,
              height: barHeight,
            ),
            Radius.circular(barWidth / 2),
          )),
        Colors.black.withOpacity(isPlaying ? 0.15 : 0.08),
        2.0,
        false,
      );
      canvas.restore();

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, maxBarHeight / 2),
            width: barWidth,
            height: barHeight,
          ),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.isMe != isMe ||
        oldDelegate.audioLevel != audioLevel ||
        oldDelegate.maxWidth != maxWidth;
  }
}
