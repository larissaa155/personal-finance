import 'package:flutter/material.dart';
import 'gradient_background.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: TextStyle(color: Colors.green[900])), centerTitle: true),
      body: GradientBackground(
        child: const Center(child: Text('Dashboard Content Here', style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
    );
  }


  Widget _summaryCard(String title, String amount, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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
