import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_state.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});
  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  static const _levels = {1: 'Beginner', 2: 'Intermediate', 3: 'Advanced'};

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, s) => s is AuthInitial,
      listener: (context, _) => context.goNamed(AppRoutes.login),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textPrimary),
                onPressed: () => context.goNamed(AppRoutes.editProfile)),
            IconButton(
                icon: const Icon(Icons.logout, color: AppColors.textPrimary),
                onPressed: () => context.read<AuthCubit>().logout()),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileFailure) {
              return Center(child: Text(state.message, style: AppTextStyles.bodyM));
            }
            if (state is ProfileSuccess) {
              final p = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: AppColors.card,
                      backgroundImage:
                          (p.profilePhotoUrl != null) ? NetworkImage(p.profilePhotoUrl!) : null,
                      child: p.profilePhotoUrl == null
                          ? const Icon(Icons.person, color: AppColors.textHint, size: 48)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(state.fullName, style: AppTextStyles.heading2),
                    const SizedBox(height: 24),
                    _row('Gender', p.gender),
                    _row('Date of Birth', DateFormat('yyyy-MM-dd').format(p.dateOfBirth)),
                    _row('Weight', '${p.weightKg} kg'),
                    _row('Height', '${p.heightCm} cm'),
                    _row('Fitness Level', _levels[p.fitnessLevel] ?? '—'),
                    _row('Goals', p.goals),
                    if (p.medicalNotes != null && p.medicalNotes!.isNotEmpty)
                      _row('Medical Notes', p.medicalNotes!),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary))),
            Expanded(child: Text(value, style: AppTextStyles.bodyM)),
          ],
        ),
      );
}
