class Transaction {

  final String id;

  final double amount;

  final bool isCredit;

  final String status;

  final String title; // Add the title field

  Transaction({
    required this.id,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.title, // Initialize the title field
  });
    
}
