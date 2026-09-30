import 'package:dio/dio.dart';

class ApiHelper {
  final Dio _dio = Dio();

  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    bool isPrivate = false,
  }) async {
    return _dio.get(endpoint, queryParameters: queryParams, options: Options());
  }

  String handleException(Object e) {
    String errorMsg;
    if (e is DioException) {
      if (e.response?.data != null) {
        var errorResponse = e.response?.data as Map<String, dynamic>;
        errorMsg = errorResponse['message'];
      } else {
        errorMsg = 'Network error happened try again later';
      }
    } else {
      errorMsg = 'error happened try again later';
    }
    return errorMsg;
  }
}
