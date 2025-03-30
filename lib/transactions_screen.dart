import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder list of transactions
    final transactions = <Transaction>[
      Transaction(id: '1', description: 'Coffee', amount: -5.5, date: DateTime.now()),
      Transaction(id: '2', description: 'Salary', amount: 1500, date: DateTime.now()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, i) {
          final t = transactions[i];
          return ListTile(
            title: Text(t.description),
            subtitle: Text(t.date.toLocal().toString()),
            trailing: Text("\$${t.amount.toStringAsFixed(2)}"),
          );
        },
      ),
    );
  }
}
