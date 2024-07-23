import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const CustomDrawer({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: onClose,
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
