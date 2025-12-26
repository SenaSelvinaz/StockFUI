
import 'package:flinder_app/features/login/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final String name;
  final String? token;
  final String? refreshToken;
  final UserRole role;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.token,
    this.refreshToken,
    required this.role,
  });

  // JSON'dan model oluştur
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['userId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? '',
      name: json['name'] ?? json['fullName'] ?? 'Kullanıcı',
      token: json['token'] ?? json['accessToken'],
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      role: UserRole.fromString(
        json['role'] ?? json['userRole'] ?? json['user_role'] ?? 'unknown',
      ),
    );
  }

  // Model'den JSON oluştur
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'fullName': name,
      'token': token,
      'refreshToken': refreshToken,
      'role': role.toApiString(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      name: name,
      token: token ?? '',
      refreshToken: refreshToken,
      role: role,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      name: entity.name ?? 'Kullanıcı',
      token: entity.token,
      refreshToken: entity.refreshToken,
      role: entity.role,
    );
  }

  // Copy with metodu
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? token,
    String? refreshToken,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, name: $name, role: ${role.toDisplayString()})';
  }
}
