import 'package:equatable/equatable.dart';
import 'package:konsul/utils/enum_values.dart';

enum AuthStatus {
  initial,
  loading,
  reloading,
  authenticated,
  unauthenticated,
  failure
}

final authStatusValues = EnumValues({
  "authenticated": AuthStatus.authenticated,
  "unauthenticated": AuthStatus.unauthenticated,
});

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.userId = '',
    this.name = '',
  });

  final AuthStatus status;
  final String? userId;
  final String? name;

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? name,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [status, name, userId];
}
