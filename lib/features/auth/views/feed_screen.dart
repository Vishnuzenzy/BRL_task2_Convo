import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convo Discussions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDiscussionCard(
            title: 'Best resources for Vector Calculus and Circuit Logic?',
            author: 'Aman Sharma',
            tag: '#FirstYear',
            replies: 14,
            likes: 29,
          ),
          _buildDiscussionCard(
            title: 'Commit Hackathon round 2 updates and tips',
            author: 'OpenSource Team',
            tag: '#Hackathon',
            replies: 32,
            likes: 64,
          ),
          _buildDiscussionCard(
            title: 'AKTU Odd-Semester exam guidelines discussion thread',
            author: 'Rahul Verma',
            tag: '#Exams',
            replies: 8,
            likes: 19,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Discussion creator opening soon!')),
          );
        },
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildDiscussionCard({
    required String title,
    required String author,
    required String tag,
    required int replies,
    required int likes,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFF1E3A8A))),
                  backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('$likes', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('$replies replies', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}