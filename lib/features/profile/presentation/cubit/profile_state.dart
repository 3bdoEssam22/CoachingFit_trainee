import 'package:coaching_fit_trainee/features/profile/domain/entities/trainee_profile.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final TraineeProfile profile;
  final String fullName;
  const ProfileSuccess(this.profile, {required this.fullName});
  @override
  List<Object?> get props => [profile, fullName];
}

class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileCreated extends ProfileState {}
class ProfileUpdated extends ProfileState {}
