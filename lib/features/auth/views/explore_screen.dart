import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search discussions, tags, or people...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          
          // Trending Tags
          const Text('Trending Tags', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTagChip('#Placements', Colors.green),
              _buildTagChip('#FirstYear', Colors.blue),
              _buildTagChip('#Hackathon', Colors.orange),
              _buildTagChip('#AKTU', Colors.purple),
              _buildTagChip('#Navadhyay', Colors.red),
            ],
          ),
          const SizedBox(height: 32),
          
          // Campus Clubs & Societies
          const Text('Campus Clubs & Societies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildClubTile(Icons.computer, 'OpenSource Team', 'Coding and open-source contributions'),
          _buildClubTile(Icons.campaign, 'Navadhyay', 'Cultural and dramatics society'),
          _buildClubTile(Icons.memory, 'Robotics Club', 'Hardware, IoT and robotics'),
          _buildClubTile(Icons.eco, 'Environment Society', 'Sustainability and green campus initiatives'),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label, Color color) {
    return Chip(
      label: Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontWeight: FontWeight.bold, fontSize: 13)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildClubTile(IconData icon, String name, String desc) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.1), 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon, color: const Color(0xFF1E3A8A)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {}, // Future navigation ke liye
    );
  }
}