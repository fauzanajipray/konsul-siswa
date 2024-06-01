import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/model/all_user.dart';
import 'package:konsul/features/dosen/bloc/mydosen_state.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
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
        AllUser userLogin = AllUser.fromJson(dosenData);

        final promises = await FirebaseFirestore.instance
            .collection('promises')
            .where('dosenId', isEqualTo: uidPembimbing)
            .where('siswaId', isEqualTo: uid)
            .where('status', isEqualTo: 'accepted')
            .get();

        bool isAlreadyAccpeted = promises.docs.isNotEmpty;

        emit(MydosenState(
          status: LoadStatus.success,
          isAlreadyAccpeted: isAlreadyAccpeted,
          user: userLogin.copyWith(id: uidPembimbing),
        ));
        return;
      }
      throw FirebaseAuthException(code: 'empty-data');
    } on FirebaseAuthException catch (e) {
      String? errorMsg;
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

      final promises = await FirebaseFirestore.instance
          .collection('promises')
          .where('siswaId', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();
      for (var doc in promises.docs) {
        await FirebaseFirestore.instance
            .collection('promises')
            .doc(doc.id)
            .delete();
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    } finally {
      await getDosen(uid); // Ensure the async function is awaited
    }
  }

  void deleteDosen(String uid, String dosenId) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'pembimbing': null,
      });

      // Check last promises order by updateAt descending
      final promises = await FirebaseFirestore.instance
          .collection('promises')
          .where('siswaId', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in promises.docs) {
        await FirebaseFirestore.instance
            .collection('promises')
            .doc(doc.id)
            .delete();
      }
      emit(const MydosenState(status: LoadStatus.success));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    } finally {
      await getDosen(uid);
    }
  }
}
