class Transaction {
  String title;
  double amount;
  DateTime date;
  String txnId;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.txnId,
  });
}
