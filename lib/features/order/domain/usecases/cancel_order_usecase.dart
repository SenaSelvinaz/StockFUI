// lib/features/order/domain/usecases/cancel_order_usecase.dart

import 'package:dartz/dartz.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure, bool>> call(int orderId) async {
    return await repository.cancelOrder(orderId);
  }
}
