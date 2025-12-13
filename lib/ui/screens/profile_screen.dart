import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.cyan),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.cyan),
            const SizedBox(height: 20),
            const Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('john@example.com'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Edit Profile')),
          ],
        ),
      ),
    );
  }
}
