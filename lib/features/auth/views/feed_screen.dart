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
  final List<String> _tags = [
    '#General',
    '#FirstYear',
    '#Coding',
    '#Exams',
    '#Hackathon',
  ];
  bool _isDarkMode =
      false; // Local state for demo; needs ThemeProvider for app-wide change

  Color _getTagColor(String tag) {
    switch (tag) {
      case '#FirstYear':
        return Colors.blue;
      case '#Coding':
        return Colors.purple;
      case '#Exams':
        return Colors.red;
      case '#Hackathon':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.indigo,
      Colors.pink,
      Colors.deepOrange,
      Colors.green,
      Colors.deepPurple,
    ];
    if (name.isEmpty) return Colors.indigo;
    return colors[name.codeUnitAt(0) % colors.length];
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of Convo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthViewModel>().logout();
    }
  }

  void _openCreateDiscussionSheet(BuildContext context) {
    final titleController = TextEditingController();
    String selectedTag = _tags[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              const Text(
                'Start a Conversation ✨',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Image Insertion Option
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image Upload coming in V2 Update! 🚀')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_outlined, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Add Image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  final isSelected = selectedTag == tag;
                  return ChoiceChip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: _getTagColor(tag),
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final text = titleController.text.trim();
                    if (text.isEmpty) return;

                    final user = context.read<AuthViewModel>().currentUser;
                    final authorName =
                        user?.displayName ??
                        (user?.email?.split('@')[0] ?? 'Campus Member');

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
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      backgroundColor: _isDarkMode ? Colors.black : Colors.grey.shade50,
      // Drawer (Three lines menu)
      drawer: Drawer(
        backgroundColor: _isDarkMode ? Colors.grey.shade900 : Colors.white,
        child: Builder(
          builder: (context) {
            final user = context.watch<AuthViewModel>().currentUser;
            final displayName =
                user?.displayName ??
                (user?.email?.split('@')[0] ?? 'AKGEC Member');
            final email = user?.email ?? 'No email';
            final initial = displayName.isNotEmpty
                ? displayName[0].toUpperCase()
                : 'U';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF1E3A8A)),
                  accountName: Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  accountEmail: Text(
                    email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    // Agar photoURL hai toh network image dikhao, warna null
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    // Agar photoURL nahi hai (jaise email signup me), tabhi Text initial dikhao
                    child: user?.photoURL == null
                        ? Text(
                            initial,
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.bookmark_border,
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  title: Text(
                    'Saved Discussions',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.groups_outlined,
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  title: Text(
                    'Campus Clubs',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.dark_mode_outlined,
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (val) => setState(() => _isDarkMode = val),
                    activeThumbColor : const Color(0xFF1E3A8A),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Pehle drawer close karo
                    _confirmLogout(context); // Fir popup dikhao
                  },
                ),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        // Search Bar in AppBar
        title: Container(
          height: 38,
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Find anything in AKGEC...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<DiscussionModel>>(
        stream: _discussionService.getDiscussionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            );
          }
          final discussions = snapshot.data ?? [];
          if (discussions.isEmpty) {
            return Center(
              child: Text(
                'No discussions yet.',
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey : Colors.black,
                ),
              ),
            );
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
                  color: _isDarkMode ? Colors.grey.shade900 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: _getAvatarColor(item.author)
                                .withValues(alpha: 0.2),
                            child: Text(
                              item.author.isNotEmpty
                                  ? item.author[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: _getAvatarColor(item.author),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.author,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: tagColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.tag,
                              style: TextStyle(
                                fontSize: 11,
                                color: tagColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _discussionService.likeDiscussion(
                              item.id,
                              item.likes,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  // Heart Icon Replaced Here
                                  const Icon(
                                    Icons.favorite_rounded,
                                    size: 16,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${item.likes}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mode_comment_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${item.replies}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () => _openCreateDiscussionSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
