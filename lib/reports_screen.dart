import 'package:flutter/material.dart';
import 'gradient_background.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports', style: TextStyle(color: Colors.green[900])), centerTitle: true),
      body: GradientBackground(
        child: const Center(child: Text('Reports Graph Here', style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
    );
  }
}

Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.blueGrey[900],
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.black38,
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
