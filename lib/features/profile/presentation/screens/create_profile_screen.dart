import 'dart:io';
import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/core/theme/text_styles.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _goals = TextEditingController();
  final _medical = TextEditingController();

  String _gender = 'Male';
  int _fitnessLevel = 1; // 1 Beginner, 2 Intermediate, 3 Advanced
  DateTime? _dob;
  File? _photo;

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

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Profile'), backgroundColor: Colors.transparent, elevation: 0),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileCreated) {
            context.goNamed(AppRoutes.home);
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            ? const Icon(Icons.add_a_photo, color: AppColors.textHint, size: 32)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    dropdownColor: AppColors.card,
                    decoration: _dec('Gender'),
                    style: AppTextStyles.bodyM,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDob,
                    child: InputDecorator(
                      decoration: _dec('Date of Birth'),
                      child: Text(
                        _dob == null ? 'Select date' : DateFormat('yyyy-MM-dd').format(_dob!),
                        style: AppTextStyles.bodyM
                            .copyWith(color: _dob == null ? AppColors.textHint : AppColors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        : Text('Save Profile', style: AppTextStyles.button),
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
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth.')),
      );
      return;
    }
    context.read<ProfileCubit>().createProfile(
          gender: _gender,
          dateOfBirth: _dob!,
          weightKg: double.parse(_weight.text),
          heightCm: double.parse(_height.text),
          fitnessLevel: _fitnessLevel,
          goals: _goals.text.trim(),
          medicalNotes: _medical.text.trim().isEmpty ? null : _medical.text.trim(),
          photo: _photo,
        );
  }
}
