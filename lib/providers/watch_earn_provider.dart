import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class WatchAndEarnProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _dailyAdLimit = 10;
  int _rewardAmount = 5;
  int _userPoints = 0;
  int _adsWatchedToday = 0;
  DateTime? _lastWatchedAd;

  int get dailyAdLimit => _dailyAdLimit;
  int get rewardAmount => _rewardAmount;
  int get userPoints => _userPoints;
  int get adsWatchedToday => _adsWatchedToday;
  DateTime? get lastWatchedAd => _lastWatchedAd;

  WatchAndEarnProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _initializeRemoteConfig();
    await _fetchUserData();
    notifyListeners();
  }

  Future<void> _initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults({
      'daily_ad_limit': 10,
      'reward_amount': 5,
    });
    await _remoteConfig.fetchAndActivate();
    _dailyAdLimit = _remoteConfig.getInt('daily_ad_limit');
    _rewardAmount = _remoteConfig.getInt('reward_amount');
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _userPoints = doc.data()?['points'] ?? 0;
        _adsWatchedToday = doc.data()?['adsWatchedToday'] ?? 0;
        final timestamp = doc.data()?['lastWatchedAd'] as Timestamp?;
        _lastWatchedAd = timestamp?.toDate();

        _resetDailyCountIfNeeded();
      }
    }
  }

  void _resetDailyCountIfNeeded() {
    if (_lastWatchedAd != null) {
      final now = DateTime.now();
      if (now.day != _lastWatchedAd!.day ||
          now.month != _lastWatchedAd!.month ||
          now.year != _lastWatchedAd!.year) {
        _adsWatchedToday = 0;
      }
    }
  }

  Future<void> watchAd() async {
    if (_adsWatchedToday < _dailyAdLimit) {
      _userPoints += _rewardAmount;
      _adsWatchedToday++;
      _lastWatchedAd = DateTime.now();

      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'points': _userPoints,
          'adsWatchedToday': _adsWatchedToday,
          'lastWatchedAd': _lastWatchedAd,
        }, SetOptions(merge: true));
      }

      notifyListeners();
    }
  }
}
