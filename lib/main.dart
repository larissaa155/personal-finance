import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/saving_goals_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Finance Manager',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/goals': (context) => const SavingGoalsScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
    );
  }
}
