// lib/features/order/data/models/bom_check_result_model.dart

import '../../domain/entities/bom_check_result_entity.dart';

class BomCheckResultModel extends BomCheckResultEntity {
  const BomCheckResultModel({
    required super.isSufficient,
    required super.insufficientItems,
    super.message,
  });

  factory BomCheckResultModel.fromJson(Map<String, dynamic> json) {
    final insufficientItems = <InsufficientItemModel>[];

    if (json['insufficientItems'] != null) {
      final items = json['insufficientItems'] as List;
      insufficientItems.addAll(
        items.map((item) => InsufficientItemModel.fromJson(item)),
      );
    }

    return BomCheckResultModel(
      isSufficient: json['isSufficient'] ?? false,
      insufficientItems: insufficientItems,
      message: json['message'],
    );
  }
}

class InsufficientItemModel extends InsufficientItemEntity {
  const InsufficientItemModel({
    required super.itemCode,
    required super.itemName,
    required super.required,
    required super.available,
    required super.missing,
  });

  factory InsufficientItemModel.fromJson(Map<String, dynamic> json) {
    return InsufficientItemModel(
      itemCode: json['itemCode'] ?? '',
      itemName: json['itemName'] ?? '',
      required: json['required'] ?? 0,
      available: json['available'] ?? 0,
      missing: json['missing'] ?? 0,
    );
  }
}
