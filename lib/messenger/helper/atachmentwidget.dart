import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AttachmentWidget extends StatelessWidget {
  final String name;
  final String type;
  final String url; // URL for the attachment

  const AttachmentWidget({
    super.key,
    required this.name,
    required this.type,
    required this.url,
  });

  Future<void> downloadAttachment(BuildContext context, String url) async {
    try {
      // Get the directory to save the file
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not get the download directory.');
      }

      String filePath = '${directory.path}/$name'; // Specify the full file path

      // Create a Dio instance
      Dio dio = Dio();

      // Start the download
      await dio.download(url, filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      });

      print('File downloaded to: $filePath');

      // Show a success message or perform other actions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded: $name')),
      );
    } catch (e) {
      print('Error downloading file: $e');

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download: $name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD5D1C7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD5D1C7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Use Expanded to allow the name and type to take available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                  maxLines: 1, // Limit to one line
                ),
                Text(
                  type,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => downloadAttachment(context, url),
          ),
        ],
      ),
    );
  }
}
