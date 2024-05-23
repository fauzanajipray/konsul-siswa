import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/login_state.dart';
import 'package:konsul/features/auth/model/user_login.dart';
import 'package:konsul/utils/load_status.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // search from collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      Map<String, dynamic> userData = userDoc.data() ?? {};
      UserLogin userLogin = UserLogin.fromJson(userData);
      if (userLogin.type == "siswa") {
        emit(state.copyWith(
            status: LoadStatus.success,
            user: userCredential.user,
            userId: userCredential.user!.uid,
            data: userLogin));
      } else {
        throw FirebaseAuthException(
            code: 'invalid-credential', message: 'Invalid Credential');
      }
    } on FirebaseAuthException catch (e) {
      String? errorMsg = '';
      if (e.code == 'invalid-credential') {
        errorMsg = 'Invalid Credential';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'The account already exists for that email.';
      } else {
        errorMsg = e.message;
      }
      emit(state.copyWith(status: LoadStatus.failure, error: errorMsg));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }
}
