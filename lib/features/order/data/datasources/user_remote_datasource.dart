// lib/features/order/data/datasources/user_remote_datasource.dart

import 'package:dio/dio.dart';

abstract class UserRemoteDataSource {
  Future<List<Map<String, dynamic>>> getUsersByRole(String role);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    final response = await dio.get(
      '/api/users/by-role/dropdown',
      queryParameters: {'role': role},
    );

    // Backend ApiResponse wrapper'ından data'yı al
    final data = response.data['data'] as List;
    return data.map((item) => item as Map<String, dynamic>).toList();
  }
}
