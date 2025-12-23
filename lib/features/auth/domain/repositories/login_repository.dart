import '../entities/user_entity.dart';

import '../entities/otp_response_entity.dart';

abstract class LoginRepository {
  /// SMS kodu gönder
  Future<OtpResponseEntity> sendOtp(String phoneNumber);

  /// SMS kodunu doğrula ve giriş yap (5 role)
  Future<UserEntity> verifyOtp(String phoneNumber, String otpCode);

  /// SMS kodunu tekrar gönder
  Future<OtpResponseEntity> resendOtp(String phoneNumber);
}
