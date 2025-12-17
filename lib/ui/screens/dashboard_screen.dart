import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../widgets/menu_card.dart';
import '../widgets/wallet_card.dart';
import '../../models/transaction_model.dart';
import '../../models/wallet_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(symbol: '€', decimalDigits: 2);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in again')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back!'),
        actions: [
          IconButton(
            tooltip: 'Send money',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.sendMoney),
            icon: const Icon(Icons.send_outlined),
            color: const Color(0xFF21C7C7),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            color: const Color(0xFF0D2B45),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<WalletModel>(
                stream: WalletService.instance.walletStream(user.uid),
                builder: (context, snapshot) {
                  final wallet =
                      snapshot.data ?? WalletModel.initial();

                  return WalletCard(
                    balance: _formatCurrency(wallet.balance),
                    income: _formatCurrency(wallet.income),
                    spent: _formatCurrency(wallet.spent),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'OVERVIEW',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  MenuCard(
                    title: 'TRANSFER',
                    icon: Icons.swap_horiz,
                    background: const Color(0xFF0D2B45),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.sendMoney),
                  ),
                  const MenuCard(
                    title: 'REQUEST',
                    icon: Icons.request_page_outlined,
                  ),
                  const MenuCard(
                    title: 'EXCHANGE',
                    icon: Icons.currency_exchange,
                  ),
                  const MenuCard(
                    title: 'CREDIT',
                    icon: Icons.credit_card,
                    background: Color(0xFF21C7C7),
                    foreground: Colors.white,
                  ),
                  const MenuCard(
                    title: 'SECURITY',
                    icon: Icons.security,
                  ),
                  const MenuCard(
                    title: 'MORE',
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'LAST TRANSACTIONS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 0.3),
                  ),
                  Icon(Icons.history, color: Color(0xFF0D2B45)),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<TransactionModel>>(
                stream:
                    WalletService.instance.recentTransactions(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  final transactions = snapshot.data ?? [];
                  if (transactions.isEmpty) {
                    return const Text(
                        'No transactions yet. Send or add funds to see history.');
                  }
                  return Column(
                    children: transactions
                        .map((tx) => ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              leading: CircleAvatar(
                                backgroundColor: tx.type ==
                                        TransactionType.income
                                    ? const Color(0xFF21C7C7)
                                    : const Color(0xFF0D2B45),
                                child: Icon(
                                  tx.type == TransactionType.income
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(tx.recipientName ??
                                  (tx.type == TransactionType.income
                                      ? 'Income'
                                      : 'Payment')),
                              subtitle: Text(
                                  DateFormat.yMMMEd().add_Hm().format(
                                      tx.createdAt.toLocal())),
                              trailing: Text(
                                '${tx.type == TransactionType.expense ? '-' : '+'}${_formatCurrency(tx.amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: tx.type == TransactionType.expense
                                      ? Colors.redAccent
                                      : Colors.green,
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
