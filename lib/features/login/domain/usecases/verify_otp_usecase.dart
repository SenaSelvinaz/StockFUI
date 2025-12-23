import '../entities/user_entity.dart';
import 'package:flinder_app/features/auth/domain/repositories/login_repository.dart';

/// SMS kodunu doğrula
class VerifyOtpUseCase {
  final LoginRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<UserEntity> call({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final cleanPhone = phoneNumber
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim();

    final cleanOtp = otpCode.replaceAll(' ', '').replaceAll('-', '').trim();

    if (cleanPhone.isEmpty) {
      throw Exception('Telefon numarası boş olamaz');
    }

    if (cleanOtp.isEmpty) {
      throw Exception('SMS kodu boş olamaz');
    }

    if (cleanOtp.length != 6) {
      throw Exception('SMS kodu 6 haneli olmalıdır');
    }

    print('📱 Temiz telefon: $cleanPhone');
    print('🔐 Temiz OTP: $cleanOtp');

    return await repository.verifyOtp(cleanPhone, cleanOtp);
  }
}
