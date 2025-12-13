import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable'), backgroundColor: Colors.cyan),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Monday: Math - 9:00 AM')),
          ListTile(title: Text('Tuesday: Physics - 10:00 AM')),
          ListTile(title: Text('Wednesday: Chemistry - 11:00 AM')),
        ],
      ),
    );
  }
}
