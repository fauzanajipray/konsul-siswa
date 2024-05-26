import 'package:equatable/equatable.dart';
import 'package:konsul/features/auth/model/user_login.dart';
import 'package:konsul/utils/load_status.dart';

class MydosenState extends Equatable {
  const MydosenState({
    this.status = LoadStatus.initial,
    this.user,
    this.error,
  });

  final LoadStatus status;
  final UserLogin? user;
  final String? error;

  MydosenState copyWith(
      {LoadStatus? status,
      Map<String, dynamic>? data,
      String? error,
      UserLogin? user}) {
    return MydosenState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}
