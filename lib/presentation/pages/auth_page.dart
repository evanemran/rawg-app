import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/auth_exception.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _setLoginMode(bool isLogin) {
    if (_isLogin == isLogin) return;

    setState(() {
      _isLogin = isLogin;
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await ref.read(signInWithEmailProvider)(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await ref.read(registerWithEmailProvider)(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(signInWithGoogleProvider)();
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Google sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.surfaceVariant,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const AuthLogoHeader(),
                    const SizedBox(height: 36),
                    _AuthModeToggle(
                      isLogin: _isLogin,
                      onLoginTap:
                          _isLoading ? null : () => _setLoginMode(true),
                      onRegisterTap:
                          _isLoading ? null : () => _setLoginMode(false),
                    ),
                    const SizedBox(height: 24),
                    if (!_isLogin) ...[
                      AuthTextField(
                        controller: _nameController,
                        label: 'Name',
                        hint: 'Your display name',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (_isLogin) return null;
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Enter your email';
                        if (!email.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      obscureText: _obscurePassword,
                      textInputAction:
                          _isLogin ? TextInputAction.done : TextInputAction.next,
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        if (!_isLogin && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (!_isLogin) ...[
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm password',
                        hint: 'Re-enter your password',
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (_isLogin) return null;
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      label: _isLogin ? 'Sign In' : 'Create Account',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AuthGoogleButton(
                      isLoading: _isLoading,
                      onPressed: _signInWithGoogle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthModeToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;

  const _AuthModeToggle({
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _ToggleChip(
            label: 'Sign In',
            selected: isLogin,
            onTap: isLogin ? null : onLoginTap,
          ),
          _ToggleChip(
            label: 'Register',
            selected: !isLogin,
            onTap: isLogin ? onRegisterTap : null,
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
