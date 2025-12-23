import 'package:flinder_app/features/auth/domain/entities/otp_response_entity.dart';
import 'package:flinder_app/features/auth/domain/repositories/login_repository.dart';

class ResendOtpUseCase {
  final LoginRepository repository;

  ResendOtpUseCase({required this.repository});

  Future<OtpResponseEntity> call(String phoneNumber) async {
    //  Telefon numarasını temizle
    final cleanPhone = phoneNumber
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim();

    if (cleanPhone.isEmpty) {
      throw Exception('Telefon numarası boş olamaz');
    }

    print(' Temiz telefon: $cleanPhone');

    //  Temiz numarayı gönder
    return await repository.resendOtp(cleanPhone);
  }
}
