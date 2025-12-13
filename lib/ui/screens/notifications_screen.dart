import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), backgroundColor: Colors.cyan),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Payment received from Alice'), trailing: Text('2h ago')),
          ListTile(title: Text('New message from John'), trailing: Text('3h ago')),
          ListTile(title: Text('Fee due reminder'), trailing: Text('5h ago')),
        ],
      ),
    );
  }
}
