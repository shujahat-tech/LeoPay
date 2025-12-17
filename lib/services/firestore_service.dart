import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides a single Firestore instance and typed helpers.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  DocumentReference<Map<String, dynamic>> walletRef(String uid) =>
      _db.collection('wallets').doc(uid);

  CollectionReference<Map<String, dynamic>> transactionsRef(String uid) =>
      _db.collection('wallets').doc(uid).collection('transactions');
}

