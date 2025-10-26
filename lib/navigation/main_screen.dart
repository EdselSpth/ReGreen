import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Placeholder(), // Home Screen
    Placeholder(), // Search Screen
    Placeholder(), // Profile Screen
  ];

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0E8),

      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xFF6B8E23),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: GNav(
            color: Colors.grey[300],
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey[200]!,
            padding: EdgeInsets.all(12),
            gap: 8,
            tabs: const [
              GButton(icon: Icons.home),
              GButton(icon: Icons.calendar_today_outlined),
              GButton(icon: Icons.person_outline),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
