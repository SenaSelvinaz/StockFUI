// lib/features/order/data/models/order_model.dart

import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    required super.productId,
    super.productCode,
    super.productName,
    super.productDescription,
    required super.quantity,
    required super.priority,
    required super.deliveryDate,
    required super.assignedToUserId,
    super.assignedToUserName,
    super.status,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  // Backend'den gelen response
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      productId: json['productId'],
      productCode: json['productCode'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      quantity: json['quantity'],
      priority: json['priority'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      assignedToUserId: json['assignedToUserId'],
      assignedToUserName: json['assignedToUserName'],
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Backend'e gönderilecek request (CreateOrderDto)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'priority': priority,
      'deliveryDate': deliveryDate.toIso8601String(),
      'assignedToUserId': assignedToUserId,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      productId: entity.productId,
      productCode: entity.productCode,
      productName: entity.productName,
      productDescription: entity.productDescription,
      quantity: entity.quantity,
      priority: entity.priority,
      deliveryDate: entity.deliveryDate,
      assignedToUserId: entity.assignedToUserId,
      assignedToUserName: entity.assignedToUserName,
      status: entity.status,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
