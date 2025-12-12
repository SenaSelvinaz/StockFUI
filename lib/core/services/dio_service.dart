// lib/services/dio_service.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class DioService {
  static Dio? _dio;

  // Singleton Pattern
  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(_baseOptions);
      _setupInterceptors();
    }
    return _dio!;
  }

  // Base URL ayarları
  static BaseOptions get _baseOptions {
    // Platform kontrolü
    String baseUrl;
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:5000'; // Android Emulator
    } else if (Platform.isIOS) {
      baseUrl = 'http://localhost:5000'; // iOS Simulator
    } else {
      baseUrl = 'http://192.168.1.XXX:5000'; // Gerçek cihaz - IP'nizi yazın
    }

    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  // Interceptor'lar (Loglama, Token ekleme vb.)
  static void _setupInterceptors() {
    _dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    // Token eklemek için
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Token varsa ekle
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Hata yönetimi
          if (error.response?.statusCode == 401) {
            // Token geçersiz - Logout
            print('Token geçersiz, logout yapılıyor...');
          }
          return handler.next(error);
        },
      ),
    );
  }
// ✅ Token'ı al (SharedPreferences'dan)
  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('❌ Token alma hatası: $e');
      return null;
    }
  }

  // ✅ Token'ı kaydet
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('✅ Token kaydedildi');
    } catch (e) {
      print('❌ Token kaydetme hatası: $e');
    }
  }

  // ✅ Token'ı sil
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      print('✅ Token silindi');
    } catch (e) {
      print('❌ Token silme hatası: $e');
    }
  }

  // ✅ Token var mı kontrol et
  static Future<bool> hasToken() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }
}