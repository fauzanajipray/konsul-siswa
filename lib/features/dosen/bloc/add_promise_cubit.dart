import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
import 'package:konsul/utils/load_status.dart';

class AddPromiseCubit extends Cubit<DataState> {
  AddPromiseCubit() : super(const DataState());

  Future<void> saveData(DateTime date, Timestamp timestamp, String? dosenId,
      String? siswaId) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      DateTime time = timestamp.toDate();
      DateTime dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute, 0);
      await FirebaseFirestore.instance.collection('promises').add({
        'dosenId': dosenId,
        'siswaId': siswaId,
        'date': dateTime,
        'status': 'pending',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      emit(state.copyWith(status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
