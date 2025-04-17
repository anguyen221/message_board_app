import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> messageBoards = const [
    {'name': 'General Chat', 'icon': Icons.forum},
    {'name': 'Tech Talk', 'icon': Icons.computer},
    {'name': 'Study Zone', 'icon': Icons.school},
    {'name': 'Random', 'icon': Icons.casino},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Boards')),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          final board = messageBoards[index];
          return ListTile(
            leading: Icon(board['icon'], color: Colors.blue),
            title: Text(board['name']),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Open "${board['name']}" board')),
              );
            },
          );
        },
      ),
    );
  }
}
