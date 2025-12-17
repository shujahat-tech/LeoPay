import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import 'firestore_service.dart';

/// Wallet + transactions helpers backed by Cloud Firestore.
class WalletService {
  WalletService._();
  static final WalletService instance = WalletService._();

  final _firestore = FirestoreService.instance;

  Stream<WalletModel> walletStream(String uid) {
    return _firestore.walletRef(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return WalletModel.initial();
      }
      return WalletModel.fromMap(doc.data()!);
    });
  }

  Stream<List<TransactionModel>> recentTransactions(String uid,
      {int limit = 10}) {
    return _firestore
        .transactionsRef(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Ensures a wallet document exists with zeroed values.
  Future<void> ensureWallet(String uid) async {
    final ref = _firestore.walletRef(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) return;

    await ref.set(WalletModel.initial().toMap());
  }

  Future<void> addIncome({
    required String uid,
    required double amount,
    String? note,
  }) {
    return _addTransaction(
      uid: uid,
      amount: amount,
      type: TransactionType.income,
      note: note,
    );
  }

  Future<void> sendMoney({
    required String uid,
    required double amount,
    required String recipientName,
    required String recipientPhone,
    String? note,
  }) {
    return _addTransaction(
      uid: uid,
      amount: amount,
      type: TransactionType.expense,
      note: note,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
    );
  }

  Future<void> _addTransaction({
    required String uid,
    required double amount,
    required TransactionType type,
    String? note,
    String? recipientName,
    String? recipientPhone,
  }) async {
    final walletRef = _firestore.walletRef(uid);
    final txRef = _firestore.transactionsRef(uid).doc();

    await _firestore.db.runTransaction((transaction) async {
      final snapshot = await transaction.get(walletRef);
      final wallet =
          snapshot.exists && snapshot.data() != null ? WalletModel.fromMap(snapshot.data()!) : WalletModel.initial();

      final updated = wallet.copyWith(
        balance: type == TransactionType.income
            ? wallet.balance + amount
            : wallet.balance - amount,
        income: type == TransactionType.income
            ? wallet.income + amount
            : wallet.income,
        spent:
            type == TransactionType.expense ? wallet.spent + amount : wallet.spent,
      );

      transaction.set(walletRef, updated.toMap());
      transaction.set(txRef, TransactionModel(
        id: txRef.id,
        amount: amount,
        type: type,
        createdAt: DateTime.now(),
        note: note,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
      ).toMap());
    });
  }
}

