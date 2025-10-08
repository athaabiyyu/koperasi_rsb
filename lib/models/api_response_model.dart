class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      message: json['message'],
      data: fromJsonT != null && json['data'] != null ? fromJsonT(json['data']) : json['data'],
      statusCode: json['statusCode'],
    );
  }
}