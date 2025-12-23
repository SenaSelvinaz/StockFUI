// lib/features/order/domain/entities/order_entity.dart

import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int? id;
  final int productId;
  final String? productCode;
  final String? productName;
  final String? productDescription;
  final int quantity;
  final String priority;
  final DateTime deliveryDate;
  final String assignedToUserId;
  final String? assignedToUserName;
  final String
  status; // "Pending", "Approved", "InProduction", "Completed", "Cancelled"
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    this.id,
    required this.productId,
    this.productCode,
    this.productName,
    this.productDescription,
    required this.quantity,
    required this.priority,
    required this.deliveryDate,
    required this.assignedToUserId,
    this.assignedToUserName,
    this.status = 'Pending',
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productCode,
    productName,
    productDescription,
    quantity,
    priority,
    deliveryDate,
    assignedToUserId,
    assignedToUserName,
    status,
    notes,
    createdAt,
    updatedAt,
  ];

  OrderEntity copyWith({
    int? id,
    int? productId,
    String? productCode,
    String? productName,
    String? productDescription,
    int? quantity,
    String? priority,
    DateTime? deliveryDate,
    String? assignedToUserId,
    String? assignedToUserName,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      quantity: quantity ?? this.quantity,
      priority: priority ?? this.priority,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUserName: assignedToUserName ?? this.assignedToUserName,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
