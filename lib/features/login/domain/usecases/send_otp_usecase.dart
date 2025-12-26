import 'package:flinder_app/features/login/domain/entities/otp_response_entity.dart';
import 'package:flinder_app/features/login/domain/repositories/login_repository.dart';

class SendOtpUseCase {
  final LoginRepository repository;

  SendOtpUseCase({required this.repository});

  Future<OtpResponseEntity> call(String phoneNumber) async {
    //  Telefon numarasını temizle (boşluk, tire, parantez)
    final cleanPhone = phoneNumber
        .replaceAll(' ', '') // Boşlukları sil
        .replaceAll('-', '') // Tireleri sil
        .replaceAll('(', '') // Parantezleri sil
        .replaceAll(')', '')
        .trim();

    if (cleanPhone.isEmpty) {
      throw Exception('Telefon numarası boş olamaz');
    }

    // Türkiye formatı kontrolü
    if (!cleanPhone.startsWith('+90')) {
      throw Exception('Telefon numarası +90 ile başlamalıdır');
    }

    // Uzunluk kontrolü (+90 dahil 13 karakter)
    if (cleanPhone.length != 13) {
      throw Exception('Telefon numarası 10 haneli olmalıdır');
    }

    print('📱 Temiz telefon: $cleanPhone'); // Debug log

    // ⭐ Temiz numarayı gönder
    return await repository.sendOtp(cleanPhone);
  }
}
