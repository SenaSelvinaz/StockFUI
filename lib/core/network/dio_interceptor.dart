// lib/core/network/dio_interceptor.dart

import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Token ekle (SharedPreferences'tan alınabilir)
    // final token = sl<SharedPreferences>().getString('auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    developer.log(
      'REQUEST[${options.method}] => PATH: ${options.path}',
      name: 'DIO',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      name: 'DIO',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      name: 'DIO',
      error: err.message,
    );

    // 401 Unauthorized - Token süresi dolmuş
    if (err.response?.statusCode == 401) {
      // Kullanıcıyı login sayfasına yönlendir
      // NavigationService.instance.navigateToPage(path: '/login');
    }

    super.onError(err, handler);
  }
}
