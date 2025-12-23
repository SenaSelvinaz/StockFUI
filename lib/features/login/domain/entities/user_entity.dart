import 'package:equatable/equatable.dart';

/// Kullanıcı rolleri (Hiyerarşik Sıralama - Rapordan)
enum UserRole {
  yonetici, // 1. Yönetici - Tüm sistem erişimi
  satinAlma, // 2. Satın Alma Birimi - Stok uyarıları
  uretimPlanlama, // 3. Üretim Planlama - Sipariş girişi, görev atama
  ustabasi, // 4. Ustabaşı - Stok girdisi, görev dağıtımı
  usta, // 5. Usta - Görev görüntüleme, işlem girişi
  unknown; // Bilinmeyen

  static UserRole fromString(String role) {
    switch (role.toLowerCase().replaceAll('_', '').replaceAll(' ', '')) {
      case 'yonetici':
      case 'admin':
      case 'administrator':
        return UserRole.yonetici;

      case 'satinalma':
      case 'satınalma':
      case 'purchasing':
        return UserRole.satinAlma;

      case 'uretimplanlama':
      case 'üretimplanlama':
      case 'productionplanning':
        return UserRole.uretimPlanlama;

      case 'ustabasi':
      case 'ustabaşı':
      case 'ustabası':
      case 'foreman':
      case 'supervisor':
        return UserRole.ustabasi;

      case 'usta':
      case 'worker':
      case 'operator':
        return UserRole.usta;

      default:
        return UserRole.unknown;
    }
  }

  String toDisplayString() {
    switch (this) {
      case UserRole.yonetici:
        return 'Yönetici';
      case UserRole.satinAlma:
        return 'Satın Alma';
      case UserRole.uretimPlanlama:
        return 'Üretim Planlama';
      case UserRole.ustabasi:
        return 'Ustabaşı';
      case UserRole.usta:
        return 'Usta';
      case UserRole.unknown:
        return 'Bilinmeyen';
    }
  }

  String toApiString() {
    switch (this) {
      case UserRole.yonetici:
        return 'yonetici';
      case UserRole.satinAlma:
        return 'satin_alma';
      case UserRole.uretimPlanlama:
        return 'uretim_planlama';
      case UserRole.ustabasi:
        return 'ustabasi';
      case UserRole.usta:
        return 'usta';
      case UserRole.unknown:
        return 'unknown';
    }
  }
}

/// Kullanıcı bilgisi
class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String token;
  final String? refreshToken;
  final UserRole role;
  final String? department; // Departman (örn: "Üretim", "Satın Alma")
  final String? position; // Pozisyon (örn: "Kalıp Ustası")

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.token,
    this.refreshToken,
    required this.role,
    this.department,
    this.position,
  });

  /// Yönetici mi?
  bool get isYonetici => role == UserRole.yonetici;

  /// Satın Alma mı?
  bool get isSatinAlma => role == UserRole.satinAlma;

  /// Üretim Planlama mı?
  bool get isUretimPlanlama => role == UserRole.uretimPlanlama;

  /// Ustabaşı mı?
  bool get isUstabasi => role == UserRole.ustabasi;

  /// Usta mı?
  bool get isUsta => role == UserRole.usta;

  /// Token var mı?
  bool get hasToken => token.isNotEmpty;

  /// Copy with
  UserEntity copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
    UserRole? role,
    String? department,
    String? position,
  }) {
    return UserEntity(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      department: department ?? this.department,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [
    id,
    phoneNumber,
    name,
    email,
    token,
    refreshToken,
    role,
    department,
    position,
  ];

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, role: ${role.toDisplayString()}, phone: $phoneNumber)';
  }
}
