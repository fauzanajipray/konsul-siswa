import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:konsul/features/auth/model/all_user.dart';
import 'package:konsul/utils/load_status.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = LoadStatus.initial,
    this.user,
    this.userId,
    this.data,
    this.error,
  });

  final LoadStatus status;
  final User? user;
  final String? userId;
  final AllUser? data;
  final String? error;

  LoginState copyWith({
    LoadStatus? status,
    User? user,
    String? userId,
    AllUser? data,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, userId, user, data, error];
}
