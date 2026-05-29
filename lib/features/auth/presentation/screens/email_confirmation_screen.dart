import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:coaching_fit_trainee/features/auth/data/repositories/auth_repository.dart';
import 'package:coaching_fit_trainee/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailConfirmationScreen extends StatelessWidget {
  const EmailConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String?;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_unread_outlined, color: AppColors.primary, size: 96),
              const SizedBox(height: 24),
              Text('Confirm your email', textAlign: TextAlign.center, style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              Text(
                'We sent a confirmation link${email != null ? ' to $email' : ''}. '
                'Open it in your browser, then come back and log in.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.login),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 52)),
                child: Text("I've confirmed — Log in", style: AppTextStyles.button),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: email == null
                    ? null
                    : () async {
                        try {
                          await sl<AuthRepository>().resendConfirmation(email);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Confirmation email resent.')),
                            );
                          }
                        } catch (_) {}
                      },
                child: Text('Resend email',
                    style: AppTextStyles.bodyM.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
