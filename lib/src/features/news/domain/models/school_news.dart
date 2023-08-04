import 'package:rv1g_info/src/features/news/domain/models/poll.dart';

class SchoolNews {
  const SchoolNews({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.text,
    required this.media,
    required this.likes,
    required this.userLiked,
    required this.pin,
    required this.poll,
    required this.createdDateTime
  });

  final int id;
  final String authorName;
  final String authorAvatar;
  final List<String> text;
  final List<String> media;
  final int likes;
  final bool userLiked;
  final bool pin;
  final Poll poll;
  final String createdDateTime;
}