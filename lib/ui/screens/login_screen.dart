import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      UserCredential credential;
      if (_isLogin) {
        credential = await AuthService.instance
            .signIn(email: email, password: password);
      } else {
        credential = await AuthService.instance.register(
          email: email,
          password: password,
          displayName: name,
        );
      }

      final uid = credential.user?.uid;
      if (uid != null) {
        await WalletService.instance.ensureWallet(uid);
      }

      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Authentication failed');
    } catch (e) {
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Icon(Icons.lock_outline,
                      size: 48, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 12),
                  Text(
                    _isLogin ? 'LOG IN' : 'CREATE ACCOUNT',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D2B45),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_isLogin) ...[
                    _RoundedField(
                      controller: _nameController,
                      hintText: 'Full name',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (_isLogin) return null;
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  _RoundedField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _RoundedField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Min 6 characters required';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomButton(
                    label: _isLogin ? 'LOG IN' : 'CREATE ACCOUNT',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _submit,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _error = null;
                            });
                          },
                    child: Text(
                      _isLogin
                          ? 'Need an account? Create one'
                          : 'Already registered? Log in',
                    ),
                  ),
                ],
              ),
            ),
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
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}