import 'package:cloud_firestore/cloud_firestore.dart';

class Withdrawal {
  final String id;
  final String userId;
  final int amount;
  final Timestamp timestamp;
  final String status;

  Withdrawal({
    required this.id,
    required this.userId,
    required this.amount,
    required this.timestamp,
    this.status = 'pending',
  });

  factory Withdrawal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Withdrawal(
      id: doc.id,
      userId: data['userId'],
      amount: data['amount'],
      timestamp: data['timestamp'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
