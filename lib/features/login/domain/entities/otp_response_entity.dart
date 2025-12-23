import 'package:equatable/equatable.dart';

/// SMS gönderim sonucu (DOMAIN)
class OtpResponseEntity extends Equatable {
  final bool success;
  final String message;
  final int? expiresIn; // saniye

  const OtpResponseEntity({
    required this.success,
    required this.message,
    this.expiresIn,
  });

  @override
  List<Object?> get props => [success, message, expiresIn];

  @override
  String toString() {
    return 'OtpResponseEntity(success: $success, message: $message, expiresIn: $expiresIn)';
  }
}
