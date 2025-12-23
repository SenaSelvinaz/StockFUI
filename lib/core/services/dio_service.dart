// lib/services/dio_service.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';

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
    if (kIsWeb) {
      baseUrl = 'http://localhost:5192';
    }else if(Platform.isAndroid){
      baseUrl = 'http://10.0.2.2:5192'; // Android Emulator

    } else if (Platform.isIOS) {
      baseUrl = 'http://localhost:5192'; // iOS Simulator
    } else {
      baseUrl = 'http://255.255.248.0:5192'; // Gerçek cihaz - IP'nizi yazın
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

    //if(!const bool.fromEnvironment('dart.vm.product')){} içine alınmışş
    _dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90
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
          //print('🔵 REQUEST[${options.method}] => ${options.path}');
          return handler.next(options);
        },
//-----------------------
        onResponse: (response, handler) {
          print(
            '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
          );
          return handler.next(response);
        },  
//------------------------
        onError: (error, handler) async {
          //-----------
          print(
            '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}',
          );
          //----------------------

          // Hata yönetimi
          if (error.response?.statusCode == 401) {
            // Token geçersiz - Logout
            print('Token geçersiz, logout yapılıyor...');
            //await logout();
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
      throw Exception('Token kaydedilemedi');
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




  // ==================== USER YÖNETİMİ ====================

  /// Kullanıcı bilgisini kaydet (JSON string olarak)
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
      print('✅ Kullanıcı bilgisi kaydedildi: ${userData['role']}');
    } catch (e) {
      print('❌ Kullanıcı kaydetme hatası: $e');
    }
  }

  /// Kullanıcı bilgisini al
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user_data');
      if (userString != null) {
        return jsonDecode(userString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Kullanıcı alma hatası: $e');
      return null;
    }
  }

  /// Kullanıcı role'ünü al
  static Future<String?> getUserRole() async {
    final userData = await getUser();
    return userData?['role'];
  }

  /// Kullanıcı ID'sini al
  static Future<String?> getUserId() async {
    final userData = await getUser();
    return userData?['id'];
  }

  /// Kullanıcı adını al
  static Future<String?> getUserName() async {
    final userData = await getUser();
    return userData?['name'];
  }

  /// Kullanıcı telefon numarasını al
  static Future<String?> getUserPhone() async {
    final userData = await getUser();
    return userData?['phoneNumber'];
  }

  /// ⭐ Kullanıcı yetkisi kontrol et (5 role için)
  static Future<bool> hasRole(List<String> allowedRoles) async {
    final userRole = await getUserRole();
    if (userRole == null) return false;
    return allowedRoles.contains(userRole.toLowerCase());
  }

  /// ⭐ Yönetici mi?
  static Future<bool> isYonetici() async {
    return await hasRole(['yonetici', 'admin']);
  }

  /// ⭐ Satın Alma mı?
  static Future<bool> isSatinAlma() async {
    return await hasRole(['satin_alma', 'satın_alma', 'purchasing']);
  }

  /// ⭐ Üretim Planlama mı?
  static Future<bool> isUretimPlanlama() async {
    return await hasRole([
      'uretim_planlama',
      'üretim_planlama',
      'production_planning',
    ]);
  }

  /// ⭐ Ustabaşı mı?
  static Future<bool> isUstabasi() async {
    return await hasRole(['ustabasi', 'ustabaşı', 'foreman', 'supervisor']);
  }

  /// ⭐ Usta mı?
  static Future<bool> isUsta() async {
    return await hasRole(['usta', 'worker', 'operator']);
  }

  /// Kullanıcı bilgisini sil
  static Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      print('✅ Kullanıcı bilgisi silindi');
    } catch (e) {
      print('❌ Kullanıcı silme hatası: $e');
    }
  }

  /// ⭐ Tam logout (token + user)
  static Future<void> logout() async {
    await clearToken();
    await clearUser();
    print('✅ Logout tamamlandı');
  }

  // ==================== HTTP METODLARI ====================

  /// GET request
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  static Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // ==================== DOSYA İŞLEMLERİ ====================

  /// Dosya upload (Form Data)
  static Future<Response> uploadFile(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    String fieldName = 'file',
    ProgressCallback? onSendProgress,
  }) async {
    FormData formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
      ...?data,
    });

    return await dio.post(path, data: formData, onSendProgress: onSendProgress);
  }

  /// Dosya download
  static Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    return await dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  // ==================== YARDIMCI METODLAR ====================

  /// Base URL'i güncelle (Runtime'da değiştirmek için)
  static void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
    print('🔄 Base URL güncellendi: $newBaseUrl');
  }

  /// Dio instance'ı sıfırla
  static void reset() {
    _dio = null;
    print('🔄 DioService sıfırlandı');
  }

  // ==================== DEBUG METODLARI ====================

  /// Current token'ı göster (DEBUG)
  static Future<void> debugPrintToken() async {
    final token = await _getToken();
    print('🔍 Current Token: ${token ?? "YOK"}');
  }

  /// Current user'ı göster (DEBUG)
  static Future<void> debugPrintUser() async {
    final user = await getUser();
    print('🔍 Current User: ${user ?? "YOK"}');
  }

  /// Tüm bilgileri göster (DEBUG)
  static Future<void> debugPrintAll() async {
    print('═══════════════════════════════════════');
    print('🔍 DEBUG INFO:');
    print('Base URL: ${dio.options.baseUrl}');
    await debugPrintToken();
    await debugPrintUser();
    print('═══════════════════════════════════════');
  }





}