import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/dosen/model/promise.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
import 'package:konsul/utils/load_status.dart';

class AvailCubit extends Cubit<DataState<Promise>> {
  AvailCubit() : super(const DataState());

  Future<void> get(String? dosenId, String? siswaId) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final docs = await FirebaseFirestore.instance
          .collection('promises')
          .where('dosenId', isEqualTo: dosenId)
          .where('siswaId', isEqualTo: siswaId)
          .where('status', whereIn: ['pending', 'accepted']).get();

      if (docs.docs.isNotEmpty) {
        Map<String, dynamic> data = docs.docs.first.data();
        String uid = docs.docs.first.id;
        Promise promise = Promise.fromJson(data).copyWith(id: uid);

        emit(state.copyWith(
          status: LoadStatus.success,
          item: promise,
        ));
      } else {
        emit(state.copyWith(
          status: LoadStatus.success,
          item: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> delete(String? uid) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      await FirebaseFirestore.instance.collection('promises').doc(uid).delete();

      emit(const DataState(
        status: LoadStatus.success,
        item: null,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }
}
