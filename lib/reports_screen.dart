import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'gradient_background.dart';
import 'database_helper.dart';
import 'transaction.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  double _income = 0.0;
  double _expenses = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await DatabaseHelper().getTransactions();
    double income = 0.0;
    double expenses = 0.0;

    for (var transaction in transactions) {
      DateTime transactionDate = DateFormat('yyyy-MM-dd').parse(transaction.date);
      if (transactionDate.month == _selectedMonth && transactionDate.year == _selectedYear) {
        if (transaction.type == "Income") {
          income += transaction.amount;
        } else {
          expenses += transaction.amount;
        }
      }
    }

    setState(() {
      _income = income;
      _expenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: Colors.green[900])),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDropdownSelectors(),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
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
                        'Income vs Expenses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: _buildBarChart()),
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

  Widget _buildDropdownSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: _selectedMonth,
          onChanged: (newValue) {
            setState(() {
              _selectedMonth = newValue!;
              _loadData();
            });
          },
          items: List.generate(12, (index) {
            return DropdownMenuItem(
              value: index + 1,
              child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
            );
          }),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: _selectedYear,
          onChanged: (newValue) {
            setState(() {
              _selectedYear = newValue!;
              _loadData();
            });
          },
          items: List.generate(10, (index) {
            int year = DateTime.now().year - index;
            return DropdownMenuItem(value: year, child: Text(year.toString()));
          }),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: _income,
                color: Colors.green,
                width: 30,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: _expenses,
                color: Colors.red,
                width: 30,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text("Income", style: TextStyle(fontWeight: FontWeight.bold));
                  case 1:
                    return const Text("Expenses", style: TextStyle(fontWeight: FontWeight.bold));
                  default:
                    return Container();
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey[900],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black38,
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/transactions');
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
}
