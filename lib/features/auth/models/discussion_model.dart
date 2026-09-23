class DiscussionModel {
  final String id;
  final String title;
  final String author;
  final String tag;
  int likes;
  int replies;
  bool isLiked;

  DiscussionModel({
    required this.id,
    required this.title,
    required this.author,
    required this.tag,
    this.likes = 0,
    this.replies = 0,
    this.isLiked = false,
  });
}