import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    this.note,
    this.recipientName,
    this.recipientPhone,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final DateTime createdAt;
  final String? note;
  final String? recipientName;
  final String? recipientPhone;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
    };
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      type: (map['type'] as String?) == TransactionType.income.name
          ? TransactionType.income
          : TransactionType.expense,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(
              (map['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ??
                  DateTime.now().millisecondsSinceEpoch),
      note: map['note'] as String?,
      recipientName: map['recipientName'] as String?,
      recipientPhone: map['recipientPhone'] as String?,
    );
  }
}

