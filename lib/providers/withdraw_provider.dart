import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewardly/models/withdrawal.dart';
import 'package:rewardly/services/withdrawal_service.dart';

class WithdrawProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final WithdrawalService _withdrawalService = WithdrawalService();

  int _userPoints = 0;
  int get userPoints => _userPoints;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  WithdrawProvider() {
    _fetchUserPoints();
  }

  Future<void> _fetchUserPoints() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _userPoints = doc.data()?['points'] ?? 0;
        notifyListeners();
      }
    }
  }

  Future<void> withdraw(int amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (amount <= 0) {
      _errorMessage = 'Amount must be greater than zero.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (amount > _userPoints) {
      _errorMessage = 'Insufficient points.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      final withdrawal = Withdrawal(
        id: ' ',
        userId: user.uid,
        amount: amount,
        timestamp: Timestamp.now(),
      );

      try {
        await _withdrawalService.createWithdrawal(withdrawal);
        _userPoints -= amount;
        await _firestore.collection('users').doc(user.uid).update({
          'points': _userPoints,
        });
      } catch (e) {
        _errorMessage = 'Error processing withdrawal. Please try again.';
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
