// lib/features/order/domain/usecases/get_order_stages_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/stage_entity.dart';
import '../repositories/order_repository.dart';
import 'package:flinder_app/core/error/failures.dart';

class GetOrderStagesUseCase {
  final OrderRepository repository;

  GetOrderStagesUseCase(this.repository);

  Future<Either<Failure, OrderStageAssignmentEntity>> call(int orderId) async {
    return await repository.getOrderStagesForAssignment(orderId);
  }
}
