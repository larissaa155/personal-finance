import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'savings_goal.dart';
import 'gradient_background.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  int _selectedIndex = 3;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  List<SavingsGoal> _savingsGoals = [];

  @override
  void initState() {
    super.initState();
    _loadSavingsGoals();
  }

  Future<void> _loadSavingsGoals() async {
    final goals = await DatabaseHelper().getSavingsGoals();
    setState(() {
      _savingsGoals = goals;
    });
  }

  Future<void> _addSavingsGoal() async {
    final title = _titleController.text;
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
    if (title.isEmpty || targetAmount <= 0) return;

    final newGoal = SavingsGoal(title: title, targetAmount: targetAmount, savedAmount: 0.0);
    await DatabaseHelper().insertSavingsGoal(newGoal);
    _titleController.clear();
    _targetAmountController.clear();
    _loadSavingsGoals();
  }

  Future<void> _deleteSavingsGoal(int id) async {
    await DatabaseHelper().deleteSavingsGoal(id);
    _loadSavingsGoals();
  }

  Future<void> _showAddMoneyDialog(SavingsGoal goal) async {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Money to ${goal.title}'),
          content: TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                double amountToAdd = double.tryParse(amountController.text) ?? 0.0;
                if (amountToAdd > 0) {
                  double newAmount = goal.savedAmount + amountToAdd;
                  await DatabaseHelper().updateSavedAmount(goal.id!, newAmount);
                  _loadSavingsGoals();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Savings Goals', style: TextStyle(color: Colors.green[900])), centerTitle: true),
      body: GradientBackground(
        child: _savingsGoals.isEmpty
            ? Center(
          child: Text(
            'No savings goals available.\nTap + to add one!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _savingsGoals.length,
                itemBuilder: (context, index) {
                  final goal = _savingsGoals[index];
                  double progress = goal.savedAmount / goal.targetAmount;

                  return Card(
                    child: ListTile(
                      title: Text(goal.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saved: \$${goal.savedAmount} / \$${goal.targetAmount}'),
                          LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey[300], color: Colors.green),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _showAddMoneyDialog(goal),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red,),
                            onPressed: () => _deleteSavingsGoal(goal.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, _selectedIndex),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Savings Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Goal Title')),
              TextField(controller: _targetAmountController, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                _addSavingsGoal();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
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
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
      BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
    ],
  );
}
