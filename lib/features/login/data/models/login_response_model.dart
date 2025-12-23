import 'package:flinder_app/features/auth/domain/entities/user_entity.dart';

class LoginResponseModel {
  final String token;
  final List<String> roles;
  final String fullName;

  const LoginResponseModel({
    required this.token,
    required this.roles,
    required this.fullName,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Login Response: $json');

      final data = json['data'];

      if (data == null) {
        throw Exception('Response data is null');
      }

      final token = data['token'] as String? ?? '';
      final rolesList = data['roles'] as List?;
      final roles = rolesList?.map((e) => e.toString()).toList() ?? <String>[];
      final fullName =
          (data['fullName'] ?? data['FullName'] ?? 'Kullanıcı') as String;

      if (token.isEmpty) {
        throw Exception('Token is empty');
      }

      return LoginResponseModel(token: token, roles: roles, fullName: fullName);
    } catch (e) {
      print('❌ LoginResponseModel parsing error: $e');
      rethrow;
    }
  }

  UserEntity toEntity() {
    // İlk role'ü al (Backend'den Worker, Admin vs geliyor)
    final roleString = roles.isNotEmpty ? roles.first : 'unknown';

    return UserEntity(
      id: '', // Backend'den ID gelmiyorsa boş
      phoneNumber: '', // Backend'den phone gelmiyorsa boş
      name: fullName,
      email: null,
      token: token,
      refreshToken: null,
      role: UserRole.fromString(roleString),
      department: null,
      position: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'roles': roles, 'fullName': fullName};
  }
}
