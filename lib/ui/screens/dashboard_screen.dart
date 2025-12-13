import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.cyan,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.cyan[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Current Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('+1,500.00 EUR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('-200.00 EUR', style: TextStyle(fontSize: 18, color: Colors.red)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _featureButton('Wallet', Icons.account_balance_wallet),
                  _featureButton('Chat', Icons.chat),
                  _featureButton('Profile', Icons.person),
                  _featureButton('Fees', Icons.payment),
                  _featureButton('Timetable', Icons.calendar_today),
                  _featureButton('Cards', Icons.credit_card),
                  _featureButton('Certificates', Icons.document_scanner),
                  _featureButton('Notifications', Icons.notifications),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _featureButton(String title, IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.cyan[900]),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
