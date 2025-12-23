// lib/features/order/data/datasources/order_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../models/bom_check_result_model.dart';
import '../models/stage_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(int id);
  Future<BomCheckResultModel> approveOrder(int id);
  Future<void> cancelOrder(int id);
  Future<BomCheckResultModel> checkBomAvailability({
    required int productId,
    required int quantity,
  });
  Future<OrderStageAssignmentModel> getOrderStagesForAssignment(int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await dio.post('/order', data: order.toJson());
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await dio.get('/order');
    final data = response.data is List ? response.data : [];
    return (data as List).map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<OrderModel> getOrderById(int id) async {
    final response = await dio.get('/order/$id');
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<BomCheckResultModel> approveOrder(int id) async {
    final response = await dio.post('/order/$id/approve');
    return BomCheckResultModel.fromJson(response.data);
  }

  @override
  Future<void> cancelOrder(int id) async {
    await dio.post('/order/$id/cancel');
  }

  @override
  Future<BomCheckResultModel> checkBomAvailability({
    required int productId,
    required int quantity,
  }) async {
    final response = await dio.post(
      '/order/check-bom',
      data: {'productId': productId, 'quantity': quantity},
    );
    return BomCheckResultModel.fromJson(response.data);
  }

  @override
  Future<OrderStageAssignmentModel> getOrderStagesForAssignment(
    int orderId,
  ) async {
    final response = await dio.get('/order/$orderId/task-stages');
    return OrderStageAssignmentModel.fromJson(response.data);
  }
}
