import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/discussion_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<DiscussionModel> _discussions = [
    DiscussionModel(
      id: '1',
      title: 'Best resources for Vector Calculus and Circuit Logic?',
      author: 'Aman Sharma',
      tag: '#FirstYear',
      likes: 29,
      replies: 14,
    ),
    DiscussionModel(
      id: '2',
      title: 'Commit Hackathon round 2 updates and tips',
      author: 'OpenSource Team',
      tag: '#Hackathon',
      likes: 64,
      replies: 32,
    ),
    DiscussionModel(
      id: '3',
      title: 'AKTU Odd-Semester exam guidelines discussion thread',
      author: 'Rahul Verma',
      tag: '#Exams',
      likes: 19,
      replies: 8,
    ),
  ];

  final List<String> _tags = ['#General', '#FirstYear', '#Coding', '#Exams', '#Hackathon'];

  void _openCreateDiscussionSheet(BuildContext context) {
    final titleController = TextEditingController();
    String selectedTag = _tags[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Start Discussion',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  )
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What topic or question do you want to discuss?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Tag:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  final isSelected = selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                    onSelected: (val) {
                      if (val) {
                        setModalState(() => selectedTag = tag);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final text = titleController.text.trim();
                    if (text.isEmpty) return;

                    final user = context.read<AuthViewModel>().currentUser;
                    final authorName = user?.displayName ?? 
                        (user?.email?.split('@')[0] ?? 'Campus Member');

                    setState(() {
                      _discussions.insert(
                        0,
                        DiscussionModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: text,
                          author: authorName,
                          tag: selectedTag,
                          likes: 0,
                          replies: 0,
                        ),
                      );
                    });

                    Navigator.pop(ctx);
                  },
                  child: const Text('Post Discussion', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convo Discussions', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _discussions.length,
        itemBuilder: (context, index) {
          final item = _discussions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.author,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                      ),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(item.tag, style: const TextStyle(fontSize: 11, color: Color(0xFF1E3A8A))),
                        backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (item.isLiked) {
                              item.likes--;
                              item.isLiked = false;
                            } else {
                              item.likes++;
                              item.isLiked = true;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(
                                item.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                size: 16,
                                color: item.isLiked ? const Color(0xFF1E3A8A) : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item.likes}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.isLiked ? const Color(0xFF1E3A8A) : Colors.grey,
                                  fontWeight: item.isLiked ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${item.replies} replies', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () => _openCreateDiscussionSheet(context),
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }
}