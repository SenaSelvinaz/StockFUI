// lib/features/order/data/models/stage_model.dart

import '../../domain/entities/stage_entity.dart';

class StageModel extends StageEntity {
  const StageModel({
    required super.stageId,
    required super.stageName,
    required super.category,
    required super.orderIndex,
    required super.isRequired,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      stageId: json['stageId'],
      stageName: json['stageName'],
      category: json['category'],
      orderIndex: json['orderIndex'],
      isRequired: json['isRequired'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stageId': stageId,
      'stageName': stageName,
      'category': category,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
    };
  }
}

class OrderStageAssignmentModel extends OrderStageAssignmentEntity {
  const OrderStageAssignmentModel({
    required super.orderId,
    required super.orderCode,
    required super.productName,
    required super.productCode,
    required super.quantity,
    required super.priority,
    super.dueDate,
    required super.suntaStages,
    required super.profilStages,
    required super.finalStages,
  });

  factory OrderStageAssignmentModel.fromJson(Map<String, dynamic> json) {
    return OrderStageAssignmentModel(
      orderId: json['orderId'],
      orderCode: json['orderCode'],
      productName: json['productName'],
      productCode: json['productCode'],
      quantity: json['quantity'],
      priority: json['priority'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      suntaStages: (json['suntaStages'] as List)
          .map((e) => StageModel.fromJson(e))
          .toList(),
      profilStages: (json['profilStages'] as List)
          .map((e) => StageModel.fromJson(e))
          .toList(),
      finalStages: (json['finalStages'] as List)
          .map((e) => StageModel.fromJson(e))
          .toList(),
    );
  }
}

class BulkTaskAssignmentModel extends BulkTaskAssignmentEntity {
  const BulkTaskAssignmentModel({
    required super.orderId,
    required super.assignments,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'assignments': assignments
          .map((a) => {'stageId': a.stageId, 'workerId': a.workerId})
          .toList(),
    };
  }
}

class TaskAssignmentResultModel extends TaskAssignmentResultEntity {
  const TaskAssignmentResultModel({
    required super.success,
    required super.message,
    required super.createdTaskCount,
    required super.createdTasks,
  });

  factory TaskAssignmentResultModel.fromJson(Map<String, dynamic> json) {
    return TaskAssignmentResultModel(
      success: json['success'],
      message: json['message'],
      createdTaskCount: json['createdTaskCount'],
      createdTasks: (json['createdTasks'] as List)
          .map((e) => CreatedTaskModel.fromJson(e))
          .toList(),
    );
  }
}

class CreatedTaskModel extends CreatedTaskEntity {
  const CreatedTaskModel({
    required super.taskId,
    required super.taskCode,
    required super.stageId,
    required super.stageName,
    required super.workerId,
    required super.workerName,
  });

  factory CreatedTaskModel.fromJson(Map<String, dynamic> json) {
    return CreatedTaskModel(
      taskId: json['taskId'],
      taskCode: json['taskCode'],
      stageId: json['stageId'],
      stageName: json['stageName'],
      workerId: json['workerId'],
      workerName: json['workerName'],
    );
  }
}
