// lib/core/di/service_locator.dart
// ✅ BACKEND UYUMLU - Yeni use case'ler eklendi

import 'package:flinder_app/core/services/dio_service.dart';
import 'package:flinder_app/features/order/data/datasources/order_remote_datasource.dart';
import 'package:flinder_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:flinder_app/features/order/domain/repositories/order_repository.dart';
import 'package:flinder_app/features/order/domain/usecases/create_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/approve_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/check_bom_availability_usecase.dart';
import 'package:flinder_app/features/order/presentation/cubit/order_cubit.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Data Sources
  late OrderRemoteDataSource _orderRemoteDataSource;

  // Repositories
  late OrderRepository _orderRepository;

  // Use Cases - Backend Uyumlu
  late CreateOrderUseCase _createOrderUseCase;
  late GetOrdersUseCase _getOrdersUseCase;
  late GetOrderDetailUseCase _getOrderDetailUseCase;
  late ApproveOrderUseCase _approveOrderUseCase;
  late CancelOrderUseCase _cancelOrderUseCase;
  late CheckBomAvailabilityUseCase _checkBomAvailabilityUseCase;

  /// Servisleri başlat
  /// baseUrl parametresi opsiyonel - DioService kendi platform detection yapar
  void init({String? baseUrl}) {
    // DioService singleton olduğu için init'e gerek yok
    // Ama baseUrl değiştirmek istersen:
    if (baseUrl != null) {
      DioService.updateBaseUrl(baseUrl);
    }

    // Initialize Data Sources
    _orderRemoteDataSource = OrderRemoteDataSourceImpl(
      dio: DioService.dio, // Singleton dio instance
    );

    // Initialize Repositories
    _orderRepository = OrderRepositoryImpl(
      remoteDataSource: _orderRemoteDataSource,
    );

    // Initialize Use Cases - Backend Endpoints
    _createOrderUseCase = CreateOrderUseCase(_orderRepository);
    _getOrdersUseCase = GetOrdersUseCase(_orderRepository);
    _getOrderDetailUseCase = GetOrderDetailUseCase(_orderRepository);
    _approveOrderUseCase = ApproveOrderUseCase(_orderRepository);
    _cancelOrderUseCase = CancelOrderUseCase(_orderRepository);
    _checkBomAvailabilityUseCase = CheckBomAvailabilityUseCase(
      _orderRepository,
    );
  }

  // Getters - Data Sources
  OrderRemoteDataSource get orderRemoteDataSource => _orderRemoteDataSource;

  // Getters - Repositories
  OrderRepository get orderRepository => _orderRepository;

  // Getters - Use Cases
  CreateOrderUseCase get createOrderUseCase => _createOrderUseCase;
  GetOrdersUseCase get getOrdersUseCase => _getOrdersUseCase;
  GetOrderDetailUseCase get getOrderDetailUseCase => _getOrderDetailUseCase;
  ApproveOrderUseCase get approveOrderUseCase => _approveOrderUseCase;
  CancelOrderUseCase get cancelOrderUseCase => _cancelOrderUseCase;
  CheckBomAvailabilityUseCase get checkBomAvailabilityUseCase =>
      _checkBomAvailabilityUseCase;

  /// Cubit Factory
  OrderCubit orderCubit() {
    return OrderCubit(
      createOrderUseCase: _createOrderUseCase,
      getOrdersUseCase: _getOrdersUseCase,
      getOrderDetailUseCase: _getOrderDetailUseCase,
      approveOrderUseCase: _approveOrderUseCase,
      cancelOrderUseCase: _cancelOrderUseCase,
      checkBomAvailabilityUseCase: _checkBomAvailabilityUseCase,
    );
  }

  /// Tüm servisleri sıfırla (Test veya logout için)
  void reset() {
    DioService.reset();
    // Diğer singleton'ları da sıfırla
  }
}

// Global instance
final serviceLocator = ServiceLocator();
