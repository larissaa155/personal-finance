import 'package:intl/intl.dart';

/// Model for a transaction
class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String? category;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    this.category,
  });
}

/// Service that provides AI-based Smart Insights
class AIInsightsService {
  /// Suggest ways to save based on habits
  List<String> getSpendingRecommendations(List<Transaction> transactions) {
    double totalSpending = transactions
        .where((t) => t.amount < 0)
        .fold(0, (sum, t) => sum + t.amount.abs());

    Map<String, double> categoryTotals = {};

    for (var t in transactions) {
      if (t.amount < 0 && t.category != null) {
        categoryTotals[t.category!] =
            (categoryTotals[t.category!] ?? 0) + t.amount.abs();
      }
    }

    List<String> suggestions = [];

    for (var entry in categoryTotals.entries) {
      double percent = (entry.value / totalSpending);
      if (percent > 0.3) {
        suggestions.add(
          "Consider reducing spending on '${entry.key}' (currently ${(percent * 100).toStringAsFixed(1)}% of total expenses).",
        );
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add("Great job! Your spending is well balanced.");
    }

    return suggestions;
  }

  /// Automatically categorize a transaction using keyword-based logic
  String autoCategorize(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('uber') || desc.contains('taxi')) return 'Transport';
    if (desc.contains('netflix') || desc.contains('spotify')) return 'Entertainment';
    if (desc.contains('mcdonald') ||
        desc.contains('restaurant') ||
        desc.contains('coffee')) return 'Food';
    if (desc.contains('rent') || desc.contains('apartment')) return 'Housing';
    if (desc.contains('gym') || desc.contains('fitness')) return 'Health';
    if (desc.contains('amazon') || desc.contains('shopping')) return 'Shopping';

    return 'Other';
  }

  /// Predicts the next month's balance using average monthly net change
  double predictNextMonthBalance(List<Transaction> transactions, double currentBalance) {
    Map<String, double> monthlyNet = {};

    for (var t in transactions) {
      String monthKey = DateFormat('yyyy-MM').format(t.date);
      monthlyNet[monthKey] = (monthlyNet[monthKey] ?? 0) + t.amount;
    }

    if (monthlyNet.isEmpty) return currentBalance;

    double averageMonthlyChange =
        monthlyNet.values.reduce((a, b) => a + b) / monthlyNet.length;

    return currentBalance + averageMonthlyChange;
  }
}

/// Example usage (can be tested in a DartPad or Flutter app)
void main() {
  final insights = AIInsightsService();

  final transactions = [
    Transaction(
      id: '1',
      description: 'Netflix Subscription',
      amount: -15.99,
      date: DateTime(2025, 3, 1),
      category: 'Entertainment',
    ),
    Transaction(
      id: '2',
      description: 'Uber Ride',
      amount: -22.50,
      date: DateTime(2025, 3, 3),
      category: 'Transport',
    ),
    Transaction(
      id: '3',
      description: 'Starbucks Coffee',
      amount: -7.80,
      date: DateTime(2025, 3, 4),
      category: 'Food',
    ),
    Transaction(
      id: '4',
      description: 'Monthly Salary',
      amount: 2000.00,
      date: DateTime(2025, 3, 1),
      category: 'Income',
    ),
  ];

  print("Spending Recommendations:");
  insights.getSpendingRecommendations(transactions).forEach(print);

  print("\n Auto Categorization:");
  print("Transaction: 'Gym Membership' => ${insights.autoCategorize('Gym Membership')}");

  print("\n Predicted Balance for Next Month:");
  double predictedBalance = insights.predictNextMonthBalance(transactions, 500.0);
  print("Predicted Balance: \$${predictedBalance.toStringAsFixed(2)}");
}
