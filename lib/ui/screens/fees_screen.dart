import 'package:flutter/material.dart';

class FeesScreen extends StatelessWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fees'), backgroundColor: Colors.cyan),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text('Total Due'),
                subtitle: const Text('€500.00'),
                trailing: ElevatedButton(onPressed: () {}, child: const Text('Pay Now')),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Fee History', style: TextStyle(fontWeight: FontWeight.bold)),
            const ListTile(title: Text('Semester 1'), trailing: Text('Paid')),
            const ListTile(title: Text('Semester 2'), trailing: Text('Pending')),
          ],
        ),
      ),
    );
  }
}
