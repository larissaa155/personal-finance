import 'package:flutter/material.dart';
import 'gradient_background.dart';
import 'database_helper.dart';
import 'transaction.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  double totalIncome = 0;
  double totalExpenses = 0;
  List<Transaction> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final transactions = await DatabaseHelper().getTransactions();
    double income = 0;
    double expenses = 0;

    for (var transaction in transactions) {
      if (transaction.type == "Income") {
        income += transaction.amount;
      } else {
        expenses += transaction.amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpenses = expenses;
      recentTransactions = transactions.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: TextStyle(color: Colors.green[900])), centerTitle: true),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance: \$${(totalIncome - totalExpenses).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Summary Cards for Income & Expenses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _summaryCard('Income', '\$${totalIncome.toStringAsFixed(2)}', Colors.green),
                  _summaryCard('Expenses', '\$${totalExpenses.toStringAsFixed(2)}', Colors.red),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Transactions
              const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Expanded(
                child: recentTransactions.isEmpty
                    ? const Center(child: Text('No transactions yet', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return ListTile(
                      leading: Icon(
                        transaction.type == "Income" ? Icons.arrow_downward : Icons.arrow_upward,
                        color: transaction.type == "Income" ? Colors.green : Colors.red,
                      ),
                      title: Text(transaction.title, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(transaction.category, style: const TextStyle(color: Colors.white70)),
                      trailing: Text(
                        '${transaction.type == "Income" ? "+" : "-"}\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.type == "Income" ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
    );
  }
  Widget _summaryCard(String title, String amount, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
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
}
