import 'package:flutter/material.dart';
import 'package:rewardly/services/referral_service.dart';

class ReferralProvider with ChangeNotifier {
  final ReferralService _referralService = ReferralService();

  String _referralCode = ' ';
  String get referralCode => _referralCode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReferralProvider() {
    _fetchReferralCode();
  }

  Future<void> _fetchReferralCode() async {
    _isLoading = true;
    notifyListeners();

    _referralCode = await _referralService.getReferralCode();

    _isLoading = false;
    notifyListeners();
  }
}
