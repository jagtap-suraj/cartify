class GeneralResponse<T> {
  final T? data;
  final String? message; // Optional success or informational message

  GeneralResponse({this.data, this.message});
}
