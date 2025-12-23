// lib/features/order/domain/usecases/create_order_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    return await repository.createOrder(order);
  }
}
