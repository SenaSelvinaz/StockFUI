// lib/features/order/domain/usecases/get_order_detail_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(int orderId) async {
    return await repository.getOrderById(orderId);
  }
}
