import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewardly/models/withdrawal.dart';

class WithdrawalService {
  final CollectionReference _withdrawalCollection;

  WithdrawalService() : _withdrawalCollection = FirebaseFirestore.instance.collection('withdrawals');

  Future<void> createWithdrawal(Withdrawal withdrawal) async {
    await _withdrawalCollection.add(withdrawal.toMap());
  }
}
