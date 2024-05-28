import 'package:equatable/equatable.dart';
import 'package:konsul/utils/load_status.dart';

class DataState<T> extends Equatable {
  const DataState({
    this.status = LoadStatus.initial,
    this.item,
    this.error,
  });

  final LoadStatus status;
  final T? item;
  final String? error;

  DataState<T> copyWith({
    LoadStatus? status,
    T? item,
    String? error,
  }) {
    return DataState<T>(
      status: status ?? this.status,
      item: item ?? this.item,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        item,
        error,
      ];
}
