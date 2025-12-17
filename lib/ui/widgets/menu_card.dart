import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    this.background = Colors.white,
    this.foreground = const Color(0xFF0D2B45),
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  color: foreground, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

