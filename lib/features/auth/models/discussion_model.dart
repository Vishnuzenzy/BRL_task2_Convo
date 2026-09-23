import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionModel {
  final String id;
  final String title;
  final String author;
  final String tag;
  final int likes;
  final int replies;
  final Timestamp? timestamp;

  DiscussionModel({
    required this.id,
    required this.title,
    required this.author,
    required this.tag,
    this.likes = 0,
    this.replies = 0,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'tag': tag,
      'likes': likes,
      'replies': replies,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory DiscussionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DiscussionModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? 'Campus Member',
      tag: data['tag'] ?? '#General',
      likes: data['likes'] ?? 0,
      replies: data['replies'] ?? 0,
      timestamp: data['timestamp'] as Timestamp?,
    );
  }
}