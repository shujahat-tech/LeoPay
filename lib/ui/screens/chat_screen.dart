import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat'), backgroundColor: Colors.cyan),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(message: 'Hi there!')),
                Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(message: 'Hello!')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type a message'))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send, color: Colors.cyan))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message),
    );
  }
}
