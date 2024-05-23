import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void setUnauthenticated() {
    emit(state.copyWith(
        status: AuthStatus.unauthenticated, userId: "", name: ""));
  }

  void setAuthenticated(String? userId, String? name) {
    emit(state.copyWith(
        status: AuthStatus.authenticated, userId: userId, name: name));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(
      status:
          authStatusValues.map[json["status"]] ?? AuthStatus.unauthenticated,
      userId: json['userId'] as String,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'status': authStatusValues.reverse[state.status],
      'userId': state.userId,
      'name': state.name,
    };
  }
}
