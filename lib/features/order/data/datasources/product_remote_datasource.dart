// lib/features/order/data/datasources/product_remote_datasource.dart

import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  /// Tüm ürünleri getir (Dropdown için)
  Future<List<Map<String, dynamic>>> getProducts();

  /// Ürün detayını getir
  Future<Map<String, dynamic>> getProductDetail(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await dio.get('/api/product');

    // Backend response'u parse et
    final data = response.data is List ? response.data : response.data['data'];

    return (data as List).map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Future<Map<String, dynamic>> getProductDetail(int id) async {
    final response = await dio.get('/api/product/$id');
    return response.data as Map<String, dynamic>;
  }
}
