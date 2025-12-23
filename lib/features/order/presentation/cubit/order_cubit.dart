// lib/features/order/presentation/cubit/order_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/approve_order_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/check_bom_availability_usecase.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderDetailUseCase getOrderDetailUseCase;
  final ApproveOrderUseCase approveOrderUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final CheckBomAvailabilityUseCase checkBomAvailabilityUseCase;

  OrderCubit({
    required this.createOrderUseCase,
    required this.getOrdersUseCase,
    required this.getOrderDetailUseCase,
    required this.approveOrderUseCase,
    required this.cancelOrderUseCase,
    required this.checkBomAvailabilityUseCase,
  }) : super(OrderInitial());

  Future<void> createOrder(OrderEntity order) async {
    emit(OrderLoading());

    final result = await createOrderUseCase(order);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderCreated(order)),
    );
  }

  Future<void> getOrders() async {
    emit(OrderLoading());

    final result = await getOrdersUseCase();

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> getOrderDetail(int orderId) async {
    emit(OrderLoading());

    final result = await getOrderDetailUseCase(orderId);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderDetailLoaded(order)),
    );
  }

  Future<void> approveOrder(int orderId) async {
    emit(OrderLoading());

    final result = await approveOrderUseCase(orderId);

    result.fold((failure) => emit(OrderError(failure.message)), (
      bomCheckResult,
    ) {
      if (bomCheckResult.isSufficient) {
        emit(
          const OrderApproved(
            message: 'Sipariş başarıyla onaylandı ve stoklar düşüldü',
          ),
        );
      } else {
        emit(
          OrderApprovalFailed(
            message: bomCheckResult.message ?? 'Stok yetersiz',
            insufficientItems: bomCheckResult.insufficientItems,
          ),
        );
      }
    });
  }

  Future<void> cancelOrder(int orderId) async {
    emit(OrderLoading());

    final result = await cancelOrderUseCase(orderId);

    result.fold((failure) => emit(OrderError(failure.message)), (success) {
      if (success) {
        emit(const OrderCancelled(message: 'Sipariş başarıyla iptal edildi'));
      } else {
        emit(const OrderError('Sipariş iptal edilemedi'));
      }
    });
  }

  /// Sipariş oluşturmadan önce veya herhangi bir zamanda
  /// ürün için gerekli malzemelerin stok kontrolünü yapar
  Future<void> checkBomAvailability({
    required int productId,
    required int quantity,
  }) async {
    emit(BomCheckLoading());

    final result = await checkBomAvailabilityUseCase(
      productId: productId,
      quantity: quantity,
    );

    result.fold(
      (failure) =>
          emit(OrderError('BOM kontrolü başarısız: ${failure.message}')),
      (bomCheckResult) => emit(BomCheckLoaded(bomCheckResult)),
    );
  }

  void reset() {
    emit(OrderInitial());
  }
}
