import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
import 'package:konsul/features/profile/model/profile.dart';
import 'package:konsul/utils/load_status.dart';

class ProfileCubit extends Cubit<DataState<Profile>> {
  ProfileCubit() : super(const DataState());

  Future<void> getProfile(String uid) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      Map<String, dynamic> userData = userDoc.data() ?? {};
      if (userData != {}) {
        Profile profile = Profile.fromJson(userData);
        emit(state.copyWith(
          status: LoadStatus.success,
          item: profile.copyWith(id: userDoc.id),
        ));
      } else {
        throw FirebaseAuthException(
            code: 'not-found', message: 'User not found');
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.message));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }
}
