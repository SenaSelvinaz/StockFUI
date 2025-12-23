// lib/core/di/injection_container.dart

import 'package:flinder_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:flinder_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:flinder_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flinder_app/features/order/data/datasources/Task_remote_datasource.dart';
import 'package:flinder_app/features/order/domain/usecases/get_order_stages_usecase.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:dio/dio.dart';

// ==================== LOGIN ====================
import '../../features/auth/data/datasources/login_datasource.dart';
import 'package:flinder_app/features/auth/data/repositories/login_repository_impl.dart';
import '../../features/auth/domain/repositories/login_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';

// ==================== ORDER ====================
import 'package:flinder_app/features/order/data/datasources/order_remote_datasource.dart';
import 'package:flinder_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:flinder_app/features/order/domain/repositories/order_repository.dart';
import 'package:flinder_app/features/order/domain/usecases/create_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/approve_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:flinder_app/features/order/domain/usecases/check_bom_availability_usecase.dart'; // ✨ YENİ
import 'package:flinder_app/features/order/presentation/cubit/order_cubit.dart';
// Core Services
import 'package:flinder_app/core/services/dio_service.dart';

final getIt = get_it.GetIt.instance;

Future<void> init() async {
  // ==================== CORE ====================

  getIt.registerLazySingleton<Dio>(() => DioService.dio);

  // ==================== LOGIN FEATURE ====================

  getIt.registerLazySingleton<LoginDataSource>(
    () => LoginDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(dataSource: getIt<LoginDataSource>()),
  );

  getIt.registerLazySingleton(
    () => SendOtpUseCase(repository: getIt<LoginRepository>()),
  );

  getIt.registerLazySingleton(
    () => VerifyOtpUseCase(repository: getIt<LoginRepository>()),
  );

  getIt.registerLazySingleton(
    () => ResendOtpUseCase(repository: getIt<LoginRepository>()),
  );

  getIt.registerFactory(
    () => LoginCubit(
      sendOtpUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      resendOtpUseCase: getIt(),
    ),
  );

  // ==================== ORDER FEATURE ====================

  // Data Source
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: getIt<OrderRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton(
    () => CreateOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt<OrderRepository>()));

  getIt.registerLazySingleton(
    () => GetOrderDetailUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton(
    () => ApproveOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton(
    () => CancelOrderUseCase(getIt<OrderRepository>()),
  );

  // ✨ YENİ: BOM Kontrolü Use Case
  getIt.registerLazySingleton(
    () => CheckBomAvailabilityUseCase(getIt<OrderRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetOrderStagesUseCase(getIt<OrderRepository>()),
  );

  // Cubit
  getIt.registerFactory(
    () => OrderCubit(
      createOrderUseCase: getIt(),
      getOrdersUseCase: getIt(),
      getOrderDetailUseCase: getIt(),
      approveOrderUseCase: getIt(),
      cancelOrderUseCase: getIt(),
      checkBomAvailabilityUseCase: getIt(), // ✨ YENİ
    ),
  );
}
