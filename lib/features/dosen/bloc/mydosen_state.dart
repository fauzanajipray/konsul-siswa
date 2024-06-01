import 'package:equatable/equatable.dart';
import 'package:konsul/features/auth/model/all_user.dart';
import 'package:konsul/utils/load_status.dart';

class MydosenState extends Equatable {
  const MydosenState({
    this.status = LoadStatus.initial,
    this.user,
    this.isAlreadyAccpeted = false,
    this.error,
  });

  final LoadStatus status;
  final AllUser? user;
  final bool isAlreadyAccpeted;
  final String? error;

  MydosenState copyWith({
    LoadStatus? status,
    Map<String, dynamic>? data,
    AllUser? user,
    bool? isAlreadyAccpeted,
    String? error,
  }) {
    return MydosenState(
      status: status ?? this.status,
      user: user ?? this.user,
      isAlreadyAccpeted: isAlreadyAccpeted ?? this.isAlreadyAccpeted,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, isAlreadyAccpeted, error];
}
