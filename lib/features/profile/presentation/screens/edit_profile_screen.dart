import 'dart:io';
import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:coaching_fit_trainee/features/profile/data/repositories/profile_repository.dart';
import 'package:coaching_fit_trainee/features/profile/domain/entities/trainee_profile.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_state.dart';
import 'package:coaching_fit_trainee/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _goals = TextEditingController();
  final _medical = TextEditingController();
  int _fitnessLevel = 1;
  File? _photo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final TraineeProfile p = await sl<ProfileRepository>().getMyProfile();
      if (!mounted) return;
      _weight.text = p.weightKg.toString();
      _height.text = p.heightCm.toString();
      _goals.text = p.goals;
      _medical.text = p.medicalNotes ?? '';
      _fitnessLevel = p.fitnessLevel;
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _goals.dispose();
    _medical.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profile'), backgroundColor: Colors.transparent, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdated) {
                  context.goNamed(AppRoutes.viewProfile);
                } else if (state is ProfileFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickPhoto,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.card,
                              backgroundImage: _photo != null ? FileImage(_photo!) : null,
                              child: _photo == null
                                  ? const Icon(Icons.add_a_photo, color: AppColors.textHint, size: 28)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(controller: _weight, decoration: _dec('Weight (kg)'), style: AppTextStyles.bodyM,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final d = double.tryParse(v ?? '');
                              return (d == null || d <= 0 || d > 500) ? 'Enter a valid weight' : null;
                            }),
                        const SizedBox(height: 16),
                        TextFormField(controller: _height, decoration: _dec('Height (cm)'), style: AppTextStyles.bodyM,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final d = double.tryParse(v ?? '');
                              return (d == null || d <= 0 || d > 300) ? 'Enter a valid height' : null;
                            }),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: _fitnessLevel,
                          dropdownColor: AppColors.card,
                          decoration: _dec('Fitness Level'),
                          style: AppTextStyles.bodyM,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Beginner')),
                            DropdownMenuItem(value: 2, child: Text('Intermediate')),
                            DropdownMenuItem(value: 3, child: Text('Advanced')),
                          ],
                          onChanged: (v) => setState(() => _fitnessLevel = v ?? 1),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(controller: _goals, decoration: _dec('Goals'), style: AppTextStyles.bodyM,
                            maxLines: 3, maxLength: 500,
                            validator: (v) => (v?.isEmpty ?? true) ? 'Tell us your goals' : null),
                        const SizedBox(height: 8),
                        TextFormField(controller: _medical, decoration: _dec('Medical Notes (optional)'),
                            style: AppTextStyles.bodyM, maxLines: 2, maxLength: 500),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: state is ProfileLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 52)),
                          child: state is ProfileLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                              : Text('Save Changes', style: AppTextStyles.button),
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().updateProfile(
          weightKg: double.parse(_weight.text),
          heightCm: double.parse(_height.text),
          fitnessLevel: _fitnessLevel,
          goals: _goals.text.trim(),
          medicalNotes: _medical.text.trim().isEmpty ? null : _medical.text.trim(),
          photo: _photo,
        );
  }
}
