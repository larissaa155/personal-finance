import 'package:flutter/material.dart';
import 'gradient_background.dart';
import 'database_helper.dart';
import 'transaction.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedIndex = 1;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await DatabaseHelper().getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  Future<void> _deleteAllTransactions() async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      await DatabaseHelper().deleteAllTransactions();
      setState(() {
        _transactions.clear();
      });
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Transactions"),
        content: const Text("Are you sure you want to delete all transaction history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: TextStyle(color: Colors.green[900])),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _transactions.isNotEmpty ? _deleteAllTransactions : null,
          ),
        ],
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _transactions.isEmpty
              ? const Center(
            child: Text(
              'No transactions available.',
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return Card(
                color: Colors.green.shade900,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(
                    transaction.type == "Income"
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction.type == "Income"
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                  title: Text(
                    transaction.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(transaction.category,
                      style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    '${transaction.type == "Income" ? "+" : "-"}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == "Income"
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[900],
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (result == true) _loadTransactions();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
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
