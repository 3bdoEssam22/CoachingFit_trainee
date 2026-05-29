import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.self_improvement, color: AppColors.primary, size: 96),
              const SizedBox(height: 24),
              Text('Find your coach.\nReach your goals.',
                  textAlign: TextAlign.center, style: AppTextStyles.heading1),
              const SizedBox(height: 16),
              Text(
                'Create your trainee profile, connect with expert coaches, and train smarter.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.register),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text('Get Started', style: AppTextStyles.button),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.goNamed(AppRoutes.login),
                child: Text('I already have an account',
                    style: AppTextStyles.bodyM.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
