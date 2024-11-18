// lib/models/video_model.dart
class VideoModel {
  final String url;
  final String title;
  final int likes;
  final int comments;

  VideoModel({
    required this.url,
    required this.title,
    this.likes = 0,
    this.comments = 0,
  });
}
