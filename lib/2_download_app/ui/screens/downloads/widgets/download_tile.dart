import 'package:flutter/material.dart';
 
import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;
 
 // TODO
  IconData get icon {
    switch (controller.status){
      case DownloadStatus.notDownloaded:
        return Icons.download;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.downloaded:
        return Icons.folder;
    }
  }

  Color get iconColor{
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child){
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.ressource.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      
                      SizedBox(height: 8),

                      Text(
                        "${(controller.progress * 100).toStringAsFixed(1)} % completed - ${(controller.ressource.size * controller.progress).toStringAsFixed(1)} of ${controller.ressource.size} MB",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 16),

                GestureDetector(
                  onTap: controller.status == DownloadStatus.notDownloaded
                    ? controller.startDownload
                    : null,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
