class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;


  Transaction({this.id, required this.title, required this.amount, required this.type, required this.category, required this.date});


  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'amount': amount, 'type': type, 'category': category, 'date': date};
  }


  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(id: map['id'], title: map['title'], amount: map['amount'], type: map['type'], category: map['category'], date: map['date']);
  }
}
