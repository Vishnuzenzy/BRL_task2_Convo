import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/discussion_model.dart';
import '../data/discussion_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final DiscussionService _discussionService = DiscussionService();
  final List<String> _tags = ['#General', '#FirstYear', '#Coding', '#Exams', '#Hackathon'];

  Color _getTagColor(String tag) {
    switch (tag) {
      case '#FirstYear': return Colors.blue;
      case '#Coding': return Colors.purple;
      case '#Exams': return Colors.red;
      case '#Hackathon': return Colors.orange;
      default: return Colors.teal;
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [Colors.indigo, Colors.pink, Colors.deepOrange, Colors.green, Colors.deepPurple];
    if (name.isEmpty) return Colors.indigo;
    return colors[name.codeUnitAt(0) % colors.length];
  }

  void _openCreateDiscussionSheet(BuildContext context) {
    final titleController = TextEditingController();
    String selectedTag = _tags[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Start a Conversation ✨', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  final isSelected = selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: _getTagColor(tag),
                    backgroundColor: Colors.grey.shade200,
                    showCheckmark: false,
                    onSelected: (val) {
                      if (val) setModalState(() => selectedTag = tag);
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final text = titleController.text.trim();
                    if (text.isEmpty) return;

                    final user = context.read<AuthViewModel>().currentUser;
                    final authorName = user?.displayName ?? (user?.email?.split('@')[0] ?? 'Campus Member');

                    await _discussionService.addDiscussion(
                      DiscussionModel(
                        id: '',
                        title: text,
                        author: authorName,
                        tag: selectedTag,
                      ),
                    );

                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Post Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Campus Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<DiscussionModel>>(
        stream: _discussionService.getDiscussionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center));
          }

          final discussions = snapshot.data ?? [];
          if (discussions.isEmpty) {
            return const Center(child: Text('No discussions yet. Start one! 🚀', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              final item = discussions[index];
              final tagColor = _getTagColor(item.tag);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: _getAvatarColor(item.author).withValues(alpha: 0.2),
                            child: Text(
                              item.author.isNotEmpty ? item.author[0].toUpperCase() : 'U',
                              style: TextStyle(color: _getAvatarColor(item.author), fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(item.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(item.tag, style: TextStyle(fontSize: 11, color: tagColor, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _discussionService.likeDiscussion(item.id, item.likes),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  const Icon(Icons.rocket_launch_rounded, size: 16, color: Colors.orange),
                                  const SizedBox(width: 6),
                                  Text('${item.likes}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                const Icon(Icons.chat_bubble_rounded, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text('${item.replies}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () => _openCreateDiscussionSheet(context),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}