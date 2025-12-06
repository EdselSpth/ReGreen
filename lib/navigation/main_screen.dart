import 'package:flutter/material.dart';
import 'package:regreen/navigation/home_page.dart';
import 'package:regreen/navigation/schedule_page.dart';
import 'package:regreen/navigation/profile_page.dart';
import 'package:regreen/edukasi/edukasipage.dart';

const Color kGreenButton = Color(0xFF6B8E23);
const Color kPageBackground = Color(0xFFF0F0E8);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SchedulePage(),
    EdukasiDaurUlangPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackground,

      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedIconTheme: const IconThemeData(color: kGreenButton),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedItemColor: kGreenButton,

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
    );
  }
}
