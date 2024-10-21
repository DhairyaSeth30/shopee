enum DataStatus { loading, success, error }

class DataState<T> {
  final DataStatus status;
  final T? data;
  final String? message;

  DataState({
    this.status = DataStatus.loading,
    this.data,
    this.message,
  });

  DataState<T> copyWith({
    DataStatus? status,
    T? data,
    String? message,
  }) {
    return DataState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
