import 'package:flutter/material.dart';
import 'gradient_background.dart';
import 'database_helper.dart';
import 'transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'Expense';
  String _selectedCategory = 'Food';

  final List<String> _categories = ['Food', 'Rent', 'Transport', 'Shopping', 'Other'];

  void _saveTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    final newTransaction = Transaction(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      type: _selectedType,
      category: _selectedCategory,
      date: DateTime.now().toString(),
    );

    await DatabaseHelper().insertTransaction(newTransaction);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: Colors.green[900])),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField(
                value: _selectedType,
                items: ['Income', 'Expense'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
