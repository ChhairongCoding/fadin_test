import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGridItem extends StatelessWidget {
  final AssetEntity asset;
  final ValueNotifier<Set<String>> selectedIds;

  const MediaGridItem(
      { required this.asset, required this.selectedIds});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return ValueListenableBuilder<Set<String>>(
          valueListenable: selectedIds,
          builder: (_, selected, __) {
            final isSelected = selected.contains(asset.id);
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  selectedIds.value = {...selected}..remove(asset.id);
                } else {
                  selectedIds.value = {...selected}..add(asset.id);
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                  ),
                  if (asset.type == AssetType.video)
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.videocam, color: Colors.white),
                    ),
                  if (isSelected)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${selected.toList().indexOf(asset.id) + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
