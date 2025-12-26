
import 'package:flinder_app/features/login/domain/entities/otp_response_entity.dart';

/// SMS Response Model (DATA)
class OtpResponseModel extends OtpResponseEntity {
  const OtpResponseModel({
    required super.success,
    required super.message,
    super.expiresIn,
  });

  /// JSON → MODEL
  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    int? expiresIn;

    if (json['expiresIn'] != null) {
      if (json['expiresIn'] is int) {
        expiresIn = json['expiresIn'];
      } else if (json['expiresIn'] is String) {
        expiresIn = int.tryParse(json['expiresIn']);
      }
    }

    return OtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      expiresIn: expiresIn,
    );
  }

  /// MODEL → JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'expiresIn': expiresIn};
  }

  /// MODEL → ENTITY
  OtpResponseEntity toEntity() {
    return OtpResponseEntity(
      success: success,
      message: message,
      expiresIn: expiresIn,
    );
  }
}
