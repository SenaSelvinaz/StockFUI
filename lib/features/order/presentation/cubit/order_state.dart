// lib/features/order/presentation/cubit/order_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/bom_check_result_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreated extends OrderState {
  final OrderEntity order;

  const OrderCreated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderDetailLoaded extends OrderState {
  final OrderEntity order;

  const OrderDetailLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderApproved extends OrderState {
  final String message;

  const OrderApproved({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderApprovalFailed extends OrderState {
  final String message;
  final List<InsufficientItemEntity> insufficientItems;

  const OrderApprovalFailed({
    required this.message,
    required this.insufficientItems,
  });

  @override
  List<Object?> get props => [message, insufficientItems];
}

class OrderCancelled extends OrderState {
  final String message;

  const OrderCancelled({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

/// BOM kontrolü yapılıyor
class BomCheckLoading extends OrderState {}

/// BOM kontrolü tamamlandı
class BomCheckLoaded extends OrderState {
  final BomCheckResultEntity result;

  const BomCheckLoaded(this.result);

  @override
  List<Object?> get props => [result];
}
