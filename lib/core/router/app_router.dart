import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== LOGIN ====================
import '../../features/auth/presentation/pages/phone_input_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';

// ==================== ORDER ====================
import 'package:flinder_app/features/order/presentation/pages/order_page.dart';
import 'package:flinder_app/features/order/presentation/pages/task_assignment_page.dart';
import 'package:flinder_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:flinder_app/features/order/domain/entities/order_entity.dart';

// ==================== CORE ====================
import 'package:flinder_app/core/services/dio_service.dart';
import '../di/injection_container.dart';

class AppRouter {
  // ==================== ROUTES ====================

  static const String phoneInput = '/';
  static const String otpVerification = '/otp-verification';
  static const String order = '/order';
  static const String taskAssignment = '/task-assignment';

  static const String yoneticiHome = '/yonetici-home';
  static const String satinAlmaHome = '/satin-alma-home';
  static const String uretimPlanlamaHome = '/uretim-planlama-home';
  static const String ustabasiHome = '/ustabasi-home';
  static const String ustaHome = '/usta-home';

  // ==================== GOROUTER ====================

  static final GoRouter router = GoRouter(
    /// 🔴 GELİŞTİRME MODU
    /// App açılır açılmaz OrderPage
    initialLocation: order,

    routes: [
      // ==================== LOGIN ====================
      GoRoute(
        path: phoneInput,
        builder: (context, state) => const PhoneInputPage(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final phoneNumber = state.extra as String?;
          return OtpVerificationPage(phoneNumber: phoneNumber ?? '');
        },
      ),

      // ==================== ORDER ====================
      GoRoute(
        path: order,
        builder: (context, state) {
          return BlocProvider<OrderCubit>(
            create: (_) => getIt<OrderCubit>(),
            child: const OrderPage(),
          );
        },
      ),

      GoRoute(
        path: taskAssignment,
        builder: (context, state) {
          // OrderEntity'yi extra'dan al
          final order = state.extra as OrderEntity?;

          // Order yoksa hata sayfası göster
          if (order == null) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F7FA),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'Hata',
                  style: TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFFF6B6B),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sipariş bilgisi bulunamadı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C7275),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go(order as String),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Sipariş Sayfasına Dön'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Order varsa TaskAssignmentPage'i göster
          return TaskAssignmentPage(order: order);
        },
      ),

      // ==================== ROLE BASED ====================
      GoRoute(
        path: yoneticiHome,
        builder: (context, state) => const YoneticiHomePage(),
      ),
      GoRoute(
        path: satinAlmaHome,
        builder: (context, state) => const SatinAlmaHomePage(),
      ),
      GoRoute(
        path: uretimPlanlamaHome,
        builder: (context, state) => const UretimPlanlamaHomePage(),
      ),
      GoRoute(
        path: ustabasiHome,
        builder: (context, state) => const UstabasiHomePage(),
      ),
      GoRoute(
        path: ustaHome,
        builder: (context, state) => const UstaHomePage(),
      ),
    ],
  );
}

// ==================== PLACEHOLDER HOME PAGES ====================

/// 1. Yönetici Ana Sayfa
class YoneticiHomePage extends StatelessWidget {
  const YoneticiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(
      context: context,
      title: 'Yönetici Paneli',
      icon: Icons.admin_panel_settings,
      color: Colors.purple,
      features: [
        'Tüm Sistem Erişimi',
        'Raporlar ve Analizler',
        'Kullanıcı Yönetimi',
        'Bildirim Takibi',
      ],
    );
  }
}

/// 2. Satın Alma Ana Sayfa
class SatinAlmaHomePage extends StatelessWidget {
  const SatinAlmaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(
      context: context,
      title: 'Satın Alma Paneli',
      icon: Icons.shopping_cart,
      color: Colors.orange,
      features: [
        'Stok Uyarıları',
        'Malzeme Tedarik',
        'Sipariş Takibi',
        'Tedarikçi Yönetimi',
      ],
    );
  }
}

/// 3. Üretim Planlama Ana Sayfa
class UretimPlanlamaHomePage extends StatelessWidget {
  const UretimPlanlamaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(
      context: context,
      title: 'Üretim Planlama Paneli',
      icon: Icons.calendar_today,
      color: Colors.blue,
      features: [
        'Sipariş Girişi',
        'Stok Kontrol',
        'Ustabaşına Görev Atama',
        'Malzeme Yeterliliği',
      ],
    );
  }
}

/// 4. Ustabaşı Ana Sayfa
class UstabasiHomePage extends StatelessWidget {
  const UstabasiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(
      context: context,
      title: 'Ustabaşı Paneli',
      icon: Icons.supervisor_account,
      color: Colors.green,
      features: [
        'Stok Girdisi',
        'Görev Görüntüleme',
        'Ustalara Görev Dağıtımı',
        'Gün Sonu İş Takibi',
      ],
    );
  }
}

/// 5. Usta Ana Sayfa
class UstaHomePage extends StatelessWidget {
  const UstaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHomePage(
      context: context,
      title: 'Usta Paneli',
      icon: Icons.build,
      color: Colors.teal,
      features: [
        'Görevlerimi Görüntüle',
        'İşlem Sayısı Girişi',
        'Fire Bildirimi',
        'Üretim Aşaması Kayıtları',
      ],
    );
  }
}

// Helper widget - Ortak home page yapısı
Widget _buildHomePage({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color color,
  required List<String> features,
}) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text(title),
      backgroundColor: color,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await DioService.logout();
            context.go('/');
          },
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Icon
            Icon(icon, size: 100, color: color),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),

            // User info
            FutureBuilder(
              future: DioService.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data as Map<String, dynamic>;
                  return Column(
                    children: [
                      Text(
                        'Hoş geldiniz, ${user['name'] ?? 'Kullanıcı'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['phoneNumber'] ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      if (user['position'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          user['position'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),

            const SizedBox(height: 48),

            // Features
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yetkileriniz:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: color, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Coming soon badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🚧 Modüller yakında eklenecek',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
  );
}
