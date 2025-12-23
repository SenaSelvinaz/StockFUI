// lib/features/order/domain/usecases/check_bom_availability_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flinder_app/core/error/failures.dart';
import '../entities/bom_check_result_entity.dart';
import '../repositories/order_repository.dart';

class CheckBomAvailabilityUseCase {
  final OrderRepository repository;

  CheckBomAvailabilityUseCase(this.repository);

  Future<Either<Failure, BomCheckResultEntity>> call({
    required int productId,
    required int quantity,
  }) async {
    return await repository.checkBomAvailability(
      productId: productId,
      quantity: quantity,
    );
  }
}
