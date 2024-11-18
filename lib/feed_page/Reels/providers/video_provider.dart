// lib/providers/video_provider.dart
import 'package:flutter/material.dart';
import 'package:navbar/feed_page/Reels/models/videomodel.dart';

class VideoProvider with ChangeNotifier {
  final List<VideoModel> _videos = [
    VideoModel(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
        title: 'Video 1',
        likes: 120,
        comments: 12),
    VideoModel(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
        title: 'Video 2',
        likes: 98,
        comments: 25),
    // Add more video URLs here...
  ];

  List<VideoModel> get videos => _videos;
}
