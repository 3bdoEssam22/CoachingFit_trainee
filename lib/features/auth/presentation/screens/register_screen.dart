import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            context.goNamed(AppRoutes.emailConfirmation, extra: _email.text.trim());
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create Account', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  Text('Join CoachingFit as a trainee',
                      style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 32),
                  TextFormField(controller: _firstName, decoration: _dec('First Name'), style: AppTextStyles.bodyM,
                      validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _lastName, decoration: _dec('Last Name'), style: AppTextStyles.bodyM,
                      validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _email, decoration: _dec('Email'), style: AppTextStyles.bodyM,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v?.contains('@') ?? false) ? null : 'Enter a valid email'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    style: AppTextStyles.bodyM,
                    decoration: _dec('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v != null && v.length >= 6) ? null : 'Min 6 characters',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _obscure,
                    style: AppTextStyles.bodyM,
                    decoration: _dec('Confirm Password'),
                    validator: (v) => v == _password.text ? null : 'Passwords do not match',
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                        : Text('Register', style: AppTextStyles.button),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
                      TextButton(
                        onPressed: () => context.goNamed(AppRoutes.login),
                        child: Text('Login',
                            style: AppTextStyles.bodyM
                                .copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
      );

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            confirmPassword: _confirm.text,
          );
    }
  }
}
