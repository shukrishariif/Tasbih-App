import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final Function(int) onItemSelected;

  const MenuScreen({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'User profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _MenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => onItemSelected(0),
                  ),
                  _MenuItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => onItemSelected(1),
                  ),
                  _MenuItem(
                    icon: Icons.info,
                    title: 'About',
                    onTap: () => onItemSelected(2),
                  ),
                  Divider(color: Colors.white24),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => onItemSelected(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
//tap it
