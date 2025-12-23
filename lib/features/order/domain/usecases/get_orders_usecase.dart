// lib/features/order/domain/usecases/get_orders_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repository.getOrders();
  }
}
