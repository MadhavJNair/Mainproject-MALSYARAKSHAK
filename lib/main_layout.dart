// ignore_for_file: unused_import

import 'package:fis/pages/fish_detection.dart';
import 'package:flutter/material.dart';
import './components/navbar.dart';
import '../pages/home_page.dart';
// import '../pages/login.dart';
import '../pages/image_picker.dart';
import '../pages/profile_page.dart';
import '../pages/sensor_page.dart'; // Import the SensorPage

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 3;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: _getBodyWidget(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return HomePage();//loginpage
      case 1:
        return RealtimeDataPage(); // Use SensorPage widget here
      case 2:
        return CaptureImg();
      case 3:
        return ProfilePage();
      default:
        return Container();
    }
  }
}
