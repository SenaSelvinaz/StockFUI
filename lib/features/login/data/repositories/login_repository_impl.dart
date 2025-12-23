// lib/features/auth/data/repositories/login_repository_impl.dart

import 'package:dio/dio.dart';
import '../../domain/entities/otp_response_entity.dart';
import '../../domain/entities/user_entity.dart';
import 'package:flinder_app/features/auth/domain/repositories/login_repository.dart';
import '../datasources/login_datasource.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImpl({required this.dataSource});

  @override
  Future<OtpResponseEntity> sendOtp(String phoneNumber) async {
    try {
      final model = await dataSource.sendOtp(phoneNumber);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final model = await dataSource.loginWithOtp(phoneNumber, otpCode);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }

  @override
  Future<OtpResponseEntity> resendOtp(String phoneNumber) async {
    try {
      final model = await dataSource.resendOtp(phoneNumber);
      return model.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }

  Exception _mapDioError(DioException e) {
    // Response yok - Network hatası
    if (e.response == null) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return Exception('Bağlantı zaman aşımına uğradı');
      }
      if (e.type == DioExceptionType.connectionError) {
        return Exception('İnternet bağlantısı yok');
      }
      return Exception('Sunucuya bağlanılamadı');
    }

    final statusCode = e.response!.statusCode;
    final data = e.response!.data;

    String message = 'Beklenmeyen bir hata oluştu';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;
    }

    // Status code'a göre özel mesajlar
    switch (statusCode) {
      case 400:
        return Exception(message);
      case 401:
        return Exception('Kod hatalı veya süresi dolmuş');
      case 404:
        return Exception('Kayıt bulunamadı');
      case 429:
        return Exception('Çok fazla deneme yaptınız. Lütfen bekleyin.');
      case 500:
        return Exception('Sunucu hatası. Lütfen daha sonra tekrar deneyin.');
      default:
        return Exception(message);
    }
  }
}
