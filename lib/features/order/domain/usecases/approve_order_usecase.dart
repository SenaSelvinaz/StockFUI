// lib/features/order/domain/usecases/approve_order_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/bom_check_result_entity.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class ApproveOrderUseCase {
  final OrderRepository repository;

  ApproveOrderUseCase(this.repository);

  Future<Either<Failure, BomCheckResultEntity>> call(int orderId) async {
    return await repository.approveOrder(orderId);
  }
}
