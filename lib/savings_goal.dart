class SavingsGoal {
  final int? id;
  final String title;
  final double targetAmount;
  final double savedAmount;

  SavingsGoal({this.id, required this.title, required this.targetAmount, required this.savedAmount});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'targetAmount': targetAmount, 'savedAmount': savedAmount};
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'],
      title: map['title'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
    );
  }
}
