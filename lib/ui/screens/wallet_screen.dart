import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet'), backgroundColor: Colors.cyan),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: const Text('Current Balance'),
              subtitle: const Text('€1,500.00'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Top Up'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(title: const Text('Payment to John'), trailing: const Text('-€50')),
          ListTile(title: const Text('Received from Alice'), trailing: const Text('+€100')),
        ],
      ),
    );
  }
}
