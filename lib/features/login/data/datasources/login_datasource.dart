// lib/features/auth/data/datasources/login_datasource.dart
// ✅ CLEAN: Sadece endpoint + model mapping

import 'package:dio/dio.dart';
import 'package:flinder_app/features/login/data/models/user_model.dart';
import 'package:flinder_app/features/login/data/models/otp_response_model.dart';
import 'package:flinder_app/features/login/data/models/login_response_model.dart';

abstract class LoginDataSource {
  /// SMS kodu gönder
  Future<OtpResponseModel> sendOtp(String phoneNumber);

  /// SMS kodu ile giriş yap
  Future<LoginResponseModel> loginWithOtp(String phoneNumber, String code);

  /// SMS kodunu tekrar gönder
  Future<OtpResponseModel> resendOtp(String phoneNumber);
}

class LoginDataSourceImpl implements LoginDataSource {
  final Dio dio;

  LoginDataSourceImpl({required this.dio});
  @override
  Future<OtpResponseModel> sendOtp(String phoneNumber) async {
    final response = await dio.post(
      '/api/auth/sms-login-send',
      data: {'phoneNumber': phoneNumber},
    );
    return OtpResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> loginWithOtp(
    String phoneNumber,
    String code,
  ) async {
    final response = await dio.post(
      '/api/auth/sms-login',
      data: {'phoneNumber': phoneNumber, 'code': code},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<OtpResponseModel> resendOtp(String phoneNumber) async {
    final response = await dio.post(
      '/api/auth/sms-resend-code',
      data: {'phoneNumber': phoneNumber},
    );
    return OtpResponseModel.fromJson(response.data);
  }
}
