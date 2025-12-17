class WalletModel {
  const WalletModel({
    required this.balance,
    required this.income,
    required this.spent,
    this.cards = const [],
  });

  final double balance;
  final double income;
  final double spent;
  final List<String> cards;

  factory WalletModel.initial() =>
      const WalletModel(balance: 0, income: 0, spent: 0, cards: []);

  WalletModel copyWith({
    double? balance,
    double? income,
    double? spent,
    List<String>? cards,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      income: income ?? this.income,
      spent: spent ?? this.spent,
      cards: cards ?? this.cards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'income': income,
      'spent': spent,
      'cards': cards,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      balance: (map['balance'] as num?)?.toDouble() ?? 0,
      income: (map['income'] as num?)?.toDouble() ?? 0,
      spent: (map['spent'] as num?)?.toDouble() ?? 0,
      cards: (map['cards'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

