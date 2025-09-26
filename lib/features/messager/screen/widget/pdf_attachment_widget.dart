import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PDFAttachmentWidget extends StatefulWidget {
  final String url;
  final String name;
  final bool isMe;
  final String time;
  final BorderRadius radius;

  const PDFAttachmentWidget({
    required this.url,
    required this.name,
    required this.isMe,
    required this.time,
    required this.radius,
  });

  @override
  State<PDFAttachmentWidget> createState() => _PDFAttachmentWidgetState();
}

class _PDFAttachmentWidgetState extends State<PDFAttachmentWidget> {
  Future<String> _getFilePath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${widget.name}';
  }

  Future<void> _loadAndOpenPDF() async {
    try {
      EasyLoading.show(status: 'Loading...');
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (!await file.exists()) {
        final response = await Dio().get(
          widget.url,
          options: Options(responseType: ResponseType.bytes),
        );
        await file.writeAsBytes(response.data);
      }

      EasyLoading.dismiss();
      await OpenFile.open(filePath);
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loadAndOpenPDF,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.isMe
              ? Theme.of(context).primaryColor
              : Colors.grey.shade50,
          borderRadius: widget.radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: widget.isMe ? Colors.white : Colors.black54,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: widget.isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                widget.time,
                style: TextStyle(
                  color: widget.isMe ? Colors.white70 : Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
