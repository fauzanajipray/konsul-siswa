import 'package:equatable/equatable.dart';
import 'package:konsul/features/auth/model/all_user.dart';
import 'package:konsul/utils/load_status.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = LoadStatus.initial,
    this.user,
    this.error,
  });

  final LoadStatus status;
  final AllUser? user;
  final String? error;

  RegisterState copyWith(
      {LoadStatus? status,
      Map<String, dynamic>? data,
      String? error,
      AllUser? user}) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}
