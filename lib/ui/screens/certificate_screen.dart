import 'package:flutter/material.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificates'), backgroundColor: Colors.cyan),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Certificate 1'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Download')),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Certificate 2'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Download')),
            ),
          ),
        ],
      ),
    );
  }
}
