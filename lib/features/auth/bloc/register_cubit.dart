import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/register_state.dart';
import 'package:konsul/features/auth/model/user_login.dart';
import 'package:konsul/utils/load_status.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  Future<void> register(
      String email, String password, String nama, String nisn) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Obtain the user ID
        String userId = user.uid;

        // Add user information to the "users" collection
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': email,
          'name': nama,
          'nisn': nisn,
          'type': 'dosen',
        });

        // Update the state with the newly created user
        emit(state.copyWith(
          status: LoadStatus.success,
          user: UserLogin(id: userId, email: email, name: nama, nisn: nisn),
          error: null,
        ));
      }
      // throw user null
      throw FirebaseAuthException(
          code: 'user-null', message: 'User Auth is null');
    } on FirebaseAuthException catch (e) {
      String? errorMsg = '';
      if (e.code == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
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
