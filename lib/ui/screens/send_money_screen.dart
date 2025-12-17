import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction_model.dart';
import '../../services/wallet_service.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _error = 'Please log in again');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final amount = double.parse(_amountController.text.trim());
      await WalletService.instance.sendMoney(
        uid: user.uid,
        amount: amount,
        recipientName: _nameController.text.trim(),
        recipientPhone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer sent')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Unable to send money. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B45),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send Money',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? '',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _RoundedField(
                      controller: _nameController,
                      hintText: 'Recipient name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),
                    _RoundedField(
                      controller: _phoneController,
                      hintText: 'Phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _RoundedField(
                      controller: _amountController,
                      hintText: 'Amount (€)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _send,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D2B45),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('SEND'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Last transactions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (user != null)
                StreamBuilder<List<TransactionModel>>(
                  stream: WalletService.instance
                      .recentTransactions(user.uid, limit: 5),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final txs = snapshot.data ?? [];
                    if (txs.isEmpty) {
                      return const Text('No transactions yet.');
                    }
                    return Column(
                      children: txs
                          .map(
                            (tx) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF21C7C7),
                                child: Icon(
                                  tx.type == TransactionType.income
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(tx.recipientName ?? 'Payment'),
                              subtitle: Text(DateFormat.yMMMd()
                                  .add_Hm()
                                  .format(tx.createdAt.toLocal())),
                              trailing: Text(
                                '${tx.type == TransactionType.expense ? '-' : '+'}${NumberFormat.currency(symbol: '€', decimalDigits: 2).format(tx.amount)}',
                                style: TextStyle(
                                  color: tx.type == TransactionType.expense
                                      ? Colors.redAccent
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
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

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );
  }
}

