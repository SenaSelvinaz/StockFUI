// lib/features/order/domain/entities/stage_entity.dart

import 'package:equatable/equatable.dart';

/// Üretim aşaması entity
class StageEntity extends Equatable {
  final int stageId;
  final String stageName;
  final String category; // "Sunta", "Profil", "Son İşlemler"
  final int orderIndex;
  final bool isRequired;

  const StageEntity({
    required this.stageId,
    required this.stageName,
    required this.category,
    required this.orderIndex,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [
    stageId,
    stageName,
    category,
    orderIndex,
    isRequired,
  ];
}

/// Sipariş aşamaları (görev atama için)
class OrderStageAssignmentEntity extends Equatable {
  final int orderId;
  final String orderCode;
  final String productName;
  final String productCode;
  final int quantity;
  final String priority;
  final DateTime? dueDate;

  final List<StageEntity> suntaStages;
  final List<StageEntity> profilStages;
  final List<StageEntity> finalStages;

  const OrderStageAssignmentEntity({
    required this.orderId,
    required this.orderCode,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.priority,
    this.dueDate,
    required this.suntaStages,
    required this.profilStages,
    required this.finalStages,
  });

  /// Tüm aşamaları tek listede döndürür
  List<StageEntity> get allStages => [
    ...suntaStages,
    ...profilStages,
    ...finalStages,
  ];

  /// Toplam aşama sayısı
  int get totalStages => allStages.length;

  @override
  List<Object?> get props => [
    orderId,
    orderCode,
    productName,
    productCode,
    quantity,
    priority,
    dueDate,
    suntaStages,
    profilStages,
    finalStages,
  ];
}

/// Görev atama bilgisi
class StageAssignment extends Equatable {
  final int stageId;
  final String workerId;
  final String? workerName;

  const StageAssignment({
    required this.stageId,
    required this.workerId,
    this.workerName,
  });

  @override
  List<Object?> get props => [stageId, workerId, workerName];
}

/// Toplu görev atama request entity
class BulkTaskAssignmentEntity extends Equatable {
  final int orderId;
  final List<StageAssignment> assignments;

  const BulkTaskAssignmentEntity({
    required this.orderId,
    required this.assignments,
  });

  @override
  List<Object?> get props => [orderId, assignments];
}

/// Görev atama sonucu
class TaskAssignmentResultEntity extends Equatable {
  final bool success;
  final String message;
  final int createdTaskCount;
  final List<CreatedTaskEntity> createdTasks;

  const TaskAssignmentResultEntity({
    required this.success,
    required this.message,
    required this.createdTaskCount,
    required this.createdTasks,
  });

  @override
  List<Object?> get props => [success, message, createdTaskCount, createdTasks];
}

/// Oluşturulan görev bilgisi
class CreatedTaskEntity extends Equatable {
  final int taskId;
  final String taskCode;
  final int stageId;
  final String stageName;
  final String workerId;
  final String workerName;

  const CreatedTaskEntity({
    required this.taskId,
    required this.taskCode,
    required this.stageId,
    required this.stageName,
    required this.workerId,
    required this.workerName,
  });

  @override
  List<Object?> get props => [
    taskId,
    taskCode,
    stageId,
    stageName,
    workerId,
    workerName,
  ];
}
