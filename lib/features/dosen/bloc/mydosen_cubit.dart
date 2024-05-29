import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/model/user_login.dart';
import 'package:konsul/features/dosen/bloc/mydosen_state.dart';
import 'package:konsul/utils/load_status.dart';

class MydosenCubit extends Cubit<MydosenState> {
  MydosenCubit() : super(const MydosenState());

  Future<void> getDosen(String uid) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      // search from collection
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      Map<String, dynamic> userData = userDoc.data() ?? {};

      String? uidPembimbing = userData['pembimbing'];
      if (uidPembimbing != null) {
        final dosenDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uidPembimbing)
            .get();

        Map<String, dynamic> dosenData = dosenDoc.data() ?? {};
        UserLogin userLogin = UserLogin.fromJson(dosenData);

        emit(state.copyWith(
            status: LoadStatus.success,
            user: userLogin.copyWith(id: uidPembimbing)));
        return;
      }
      throw FirebaseAuthException(code: 'empty-data');
    } on FirebaseAuthException catch (e) {
      String? errorMsg = '';
      if (e.code == 'empty-data') {
        errorMsg = 'Dosen pembimbing belum dipilih';
      } else {
        errorMsg = e.message;
      }
      emit(state.copyWith(status: LoadStatus.failure, error: errorMsg));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }

  Future<void> setDosen(String uid, String uidDosen) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'pembimbing': uidDosen,
      });

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      Map<String, dynamic> userData = userDoc.data() ?? {};

      String? uidPembimbing = userData['pembimbing'];
      if (uidPembimbing != null) {
        final dosenDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uidPembimbing)
            .get();

        Map<String, dynamic> dosenData = dosenDoc.data() ?? {};
        UserLogin userLogin = UserLogin.fromJson(dosenData);

        emit(state.copyWith(status: LoadStatus.success, user: userLogin));
        return;
      }
      throw FirebaseAuthException(code: 'empty-data');
    } on FirebaseAuthException catch (e) {
      String? errorMsg = '';
      if (e.code == 'empty-data') {
        errorMsg = 'Dosen pembimbing belum dipilih';
      } else {
        errorMsg = e.message;
      }
      emit(state.copyWith(status: LoadStatus.failure, error: errorMsg));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }
}
