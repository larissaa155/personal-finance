import 'package:flutter/material.dart';
import 'gradient_background.dart';
import 'database_helper.dart';
import 'transaction.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> _transactions = [];
  double _balance = 3000.0;
  double _income = 0.0;
  double _expenses = 0.0;
  Map<String, double> _expenseCategories = {};

  final Map<String, Color> categoryColors = {
    "Food": Colors.red,
    "Shopping": Colors.blue,
    "Entertainment": Colors.purple,
    "Transport": Colors.orange,
    "Bills": Colors.green,
    "Others": Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await DatabaseHelper().getTransactions();
    double income = 0.0;
    double expenses = 0.0;
    Map<String, double> expenseCategories = {};

    for (var transaction in transactions) {
      if (transaction.type == "Income") {
        income += transaction.amount;
      } else {
        expenses += transaction.amount;
        expenseCategories[transaction.category] =
            (expenseCategories[transaction.category] ?? 0) + transaction.amount;
      }
    }

    setState(() {
      _transactions = transactions;
      _income = income;
      _expenses = expenses;
      _balance = 3000.0 + income - expenses;
      _expenseCategories = expenseCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Colors.green[900])),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '\$${_balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard("Income", _income, Colors.green.shade900),
                        const SizedBox(width: 12),
                        _buildInfoCard("Expenses", _expenses, Colors.red.shade900),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _transactions.isEmpty
                    ? const Center(
                  child: Text(
                    'No transactions available.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Expense by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: PieChartWidget(
                          expenseCategories: _expenseCategories,
                          categoryColors: categoryColors,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildExpenseLegend(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildInfoCard(String title, double amount, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey[900],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black38,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
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
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
      ],
    );
  }

  Widget _buildExpenseLegend() {
    double total = _expenseCategories.values.fold(0, (sum, amount) => sum + amount);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: _expenseCategories.entries.map((entry) {
        double percentage = (entry.value / total) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: categoryColors[entry.key] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${entry.key}: ${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, double> expenseCategories;
  final Map<String, Color> categoryColors;

  const PieChartWidget({super.key, required this.expenseCategories, required this.categoryColors});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: expenseCategories.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            color: categoryColors[entry.key] ?? Colors.grey,
            radius: 50,
            titleStyle: const TextStyle(color: Colors.transparent),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
