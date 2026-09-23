import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/discussion_model.dart';

class DiscussionService {
  final CollectionReference _db = FirebaseFirestore.instance.collection('discussions');

  // Real-time stream of discussions (Newest first)
  Stream<List<DiscussionModel>> getDiscussionsStream() {
    return _db.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DiscussionModel.fromFirestore(doc)).toList();
    });
  }

  // Add new discussion to Firestore
  Future<void> addDiscussion(DiscussionModel discussion) async {
    await _db.add(discussion.toMap());
  }

  // Increment Likes
  Future<void> likeDiscussion(String id, int currentLikes) async {
    await _db.doc(id).update({'likes': currentLikes + 1});
  }
}