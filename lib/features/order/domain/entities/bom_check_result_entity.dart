// lib/features/order/domain/entities/bom_check_result_entity.dart

import 'package:equatable/equatable.dart';

class BomCheckResultEntity extends Equatable {
  final bool isSufficient;
  final List<InsufficientItemEntity> insufficientItems;
  final String? message;

  const BomCheckResultEntity({
    required this.isSufficient,
    required this.insufficientItems,
    this.message,
  });

  @override
  List<Object?> get props => [isSufficient, insufficientItems, message];
}

class InsufficientItemEntity extends Equatable {
  final String itemCode;
  final String itemName;
  final int required;
  final int available;
  final int missing;

  const InsufficientItemEntity({
    required this.itemCode,
    required this.itemName,
    required this.required,
    required this.available,
    required this.missing,
  });

  bool get isAvailable => available >= required;
  bool get hasPartial => available > 0 && available < required;
  bool get isUnavailable => available == 0;

  @override
  List<Object?> get props => [itemCode, itemName, required, available, missing];
}
