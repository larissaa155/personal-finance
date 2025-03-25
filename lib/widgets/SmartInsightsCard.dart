import 'package:flutter/material.dart';
import '../services/ai_insights_service.dart';

class SmartInsightsCard extends StatelessWidget {
  final List<Transaction> transactions;
  final double currentBalance;

  const SmartInsightsCard({
    Key? key,
    required this.transactions,
    required this.currentBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insights = AIInsightsService();
    final recommendations = insights.getSpendingRecommendations(transactions);
    final predictedBalance =
        insights.predictNextMonthBalance(transactions, currentBalance);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Smart Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Predicted Next Month Balance: \$${predictedBalance.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                color: predictedBalance >= currentBalance
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Recommendations:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ",
                          style: TextStyle(fontSize: 16, height: 1.5)),
                      Expanded(
                        child: Text(
                          rec,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
