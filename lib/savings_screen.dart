import 'package:flutter/material.dart';
import 'gradient_background.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Savings Goals', style: TextStyle(color: Colors.green[900])), centerTitle: true),
      body: GradientBackground(
        child: const Center(child: Text('Savings Goals Here', style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
    );
  }
}

Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.blueGrey[900], // Dark background
    selectedItemColor: Colors.green, // Green color for selected tab
    unselectedItemColor: Colors.black38, // White for unselected tabs
    currentIndex: currentIndex,
    onTap: (index) {
      if (index != currentIndex) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/transactions');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/reports');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/savings');
            break;
        }
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'Transactions',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Reports',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.savings),
        label: 'Savings',
      ),
    ],
  );
}
