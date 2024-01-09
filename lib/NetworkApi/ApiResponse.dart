class ApiResponse<T> {
  final T? data;
  final ApiError? error;

  ApiResponse({this.data, this.error});

  bool get isSuccess => error == null;
}

class ApiError {
  final String message;
  final int? status;

  ApiError({required this.message, this.status});
}
