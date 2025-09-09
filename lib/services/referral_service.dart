import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getReferralCode() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('referralCode')) {
        return doc.data()!['referralCode'];
      } else {
        return _generateAndSaveReferralCode(user.uid);
      }
    }
    return ' ';
  }

  Future<String> _generateAndSaveReferralCode(String userId) async {
    final code = _generateRandomCode();
    await _firestore.collection('users').doc(userId).set({
      'referralCode': code,
    }, SetOptions(merge: true));
    return code;
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
