// lib/features/order/domain/repositories/order_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../entities/bom_check_result_entity.dart';
import '../entities/stage_entity.dart';
import 'package:flinder_app/core/error/failures.dart';

abstract class OrderRepository {
  // POST /api/order
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);

  // GET /api/order
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  // GET /api/order/{id}
  Future<Either<Failure, OrderEntity>> getOrderById(int id);

  // POST /api/order/{id}/approve
  Future<Either<Failure, BomCheckResultEntity>> approveOrder(int id);

  // POST /api/order/{id}/cancel
  Future<Either<Failure, bool>> cancelOrder(int id);

  // POST /api/order/check-bom
  Future<Either<Failure, BomCheckResultEntity>> checkBomAvailability({
    required int productId,
    required int quantity,
  });

  /// Sipariş için görev atama ekranında gösterilecek aşamaları getirir
  Future<Either<Failure, OrderStageAssignmentEntity>>
  getOrderStagesForAssignment(int orderId);
}
