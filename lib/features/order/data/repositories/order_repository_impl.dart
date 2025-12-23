// lib/features/order/data/repositories/order_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/bom_check_result_entity.dart';
import '../../domain/entities/stage_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';
import '../models/bom_check_result_model.dart';
import 'package:flinder_app/core/error/failures.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      final result = await remoteDataSource.createOrder(orderModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final result = await remoteDataSource.getOrders();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int id) async {
    try {
      final result = await remoteDataSource.getOrderById(id);
      return Right(result);
    } on DioException catch (e) {
      // ✅ 404 kontrolü BURADA
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(message: 'Sipariş bulunamadı'));
      }
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, BomCheckResultEntity>> approveOrder(int id) async {
    try {
      final result = await remoteDataSource.approveOrder(id);
      return Right(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        try {
          final bomResult = BomCheckResultModel.fromJson(e.response!.data);
          return Right(bomResult);
        } catch (_) {
          // Parse edilemezse normal error
          return Left(ServerFailure(message: _getErrorMessage(e)));
        }
      }
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(message: 'Sipariş bulunamadı'));
      }
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder(int id) async {
    try {
      await remoteDataSource.cancelOrder(id);
      return const Right(true);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(message: 'Sipariş bulunamadı'));
      }
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, BomCheckResultEntity>> checkBomAvailability({
    required int productId,
    required int quantity,
  }) async {
    try {
      final result = await remoteDataSource.checkBomAvailability(
        productId: productId,
        quantity: quantity,
      );
      return Right(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        try {
          final bomResult = BomCheckResultModel.fromJson(e.response!.data);
          return Right(bomResult);
        } catch (_) {
          return Left(ServerFailure(message: _getErrorMessage(e)));
        }
      }
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OrderStageAssignmentEntity>>
  getOrderStagesForAssignment(int orderId) async {
    try {
      final stages = await remoteDataSource.getOrderStagesForAssignment(
        orderId,
      );
      return Right(stages);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(message: 'Sipariş bulunamadı'));
      }
      return Left(ServerFailure(message: _getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen hata: ${e.toString()}'));
    }
  }

  String _getErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['title'] ?? 'Sunucu hatası';
    }

    // Network hatası vs.
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Bağlantı zaman aşımına uğradı';
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Sunucu yanıt vermiyor';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'İnternet bağlantısı yok';
    }

    return 'Sunucu hatası';
  }
}
