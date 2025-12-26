import 'package:flutter/foundation.dart';

// 1. Enum tanımı (Dosyanın en üstünde kalsın)
enum ProcessType {
  kesim,
  kaynak,
  delikleme,
  paketleme
}
/*
extension ProcessTypeX on ProcessType {
  String get label => switch (this) {
        ProcessType.kesim => "Kesim",
        ProcessType.delikleme => "Delikleme",
        ProcessType.kaynak => "Kaynak",
        ProcessType.paketleme => "Paketleme",
      };
}*/

extension ProcessTypeX on ProcessType {
  String get label {
    switch (this) {
      case ProcessType.kesim:
        return "Kesim";
      case ProcessType.delikleme:
        return "Delikleme";
      case ProcessType.kaynak:
        return "Kaynak";
      case ProcessType.paketleme:
        return "Paketleme";
    }
  }
}

// 2. ViewModel Sınıfı
class PendingTaskCardVm {
  final String taskId;
  final String orderCode;
  final String productName;
  final int orderedQty;
  final ProcessType processType;
  final int processQty;

  const PendingTaskCardVm({
    required this.taskId,
    required this.orderCode,
    required this.productName,
    required this.orderedQty,
    required this.processType,
    required this.processQty,
  });

  // Backend'den gelen veriyi modele dönüştürür
  factory PendingTaskCardVm.fromMap(Map<String, dynamic> json) {
    return PendingTaskCardVm(
      taskId: json['id']?.toString() ?? '',

      orderCode: (json['orderCode'] ?? '-').toString(),
      
      productName: (json['productName'] ?? 'Bilinmeyen Ürün').toString(),

      orderedQty: (json['orderedQty'] as num?)?.toInt() ?? 
      (json['quantity'] as num?)?.toInt() // fallback
      ?? 0,

      processQty: (json['processQty'] as num?)?.toInt()
        ?? (json['targetQty'] as num?)?.toInt() // ileride hedef qty diye dönerse
        ?? (json['processedQty'] as num?)?.toInt() // eğer backend böyle döndürürse
        ?? 0,

      processType: _mapStageToProcessType(json['stageName'] as String?),
    );
  }

  // String stage ismini Enum tipine çevirir
  // ✅ tek ve sağlam mapping (contains)
  static ProcessType _mapStageToProcessType(String? stage) {
    final s = (stage ?? '').toLowerCase();

    if (s.contains('kes')) return ProcessType.kesim;
    if (s.contains('delik') || s.contains('delme') || s.contains('drill')) {
      return ProcessType.delikleme;
    }
    if (s.contains('kaynak') || s.contains('weld')) return ProcessType.kaynak;
    if (s.contains('paket') || s.contains('pack')) return ProcessType.paketleme;

    return ProcessType.kesim; // default
  }
}