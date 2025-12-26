import 'package:flutter/material.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flinder_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flinder_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flinder_app/features/auth/presentation/widgets/worker_list_item.dart';

import 'package:flinder_app/features/auth/domain/entities/worker.dart';
import 'package:dio/dio.dart'; // Dio için
import 'package:flinder_app/core/services/api_service.dart';

class WorkerListPage extends StatefulWidget {
  const WorkerListPage({super.key});

  @override
  State<WorkerListPage> createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  final TextEditingController searchController = TextEditingController();

  @override
void initState() {
  super.initState();
  // Sayfa ilk yüklendiğinde API'den verileri çek
  _fetchAndLoadWorkers(); 
}

  // _WorkerListPageState sınıfı içinde

// ✅ YENİ: Veritabanındaki tüm kullanıcıları çekme fonksiyonu
Future<void> _fetchAndLoadWorkers() async {
  // Yüklenme durumuna geçiş (isteğe bağlı, zaten BlocBuilder AuthLoading ile ilgileniyor olabilir)
  // context.read<AuthCubit>().emit(AuthLoading()); // Eğer gerekliyse
    
  try {
    // API çağrısı: GET /api/admin/users
    final response = await ApiService.get("/api/admin/users");
    
    // API'den gelen veriyi (data listesi) alalım
    final List rawWorkers = response.data['data'] ?? [];
    
    // Worker Entity listesine dönüştürelim
    final List<Worker> workers = rawWorkers.map((item) {
        // Backend'den gelen veriyi Worker Entity'sine dönüştürme:
        // Not: Bu kısım AddWorkerPage'deki mantıkla uyumlu olmalı
        

        final String phoneNumber = (item['phoneNumber'] as String? ?? '').replaceAll(' ', '');
        

        return Worker(
            name: item['fullName'] ?? 'İsimsiz', // FullName null ise 'İsimsiz' ata.
            //phone: phoneNumber.replaceAll(' ', ''), // 905XXXXXXXXX,
            phone: phoneNumber, // 905XXXXXXXXX,
            role: item['role'] ?? 'Worker', // Department null ise 'Worker' ata.
        );
    }).toList();
    
    // Cubit'e yükleme işlemini yapın
    if (mounted) {
        context.read<AuthCubit>().loadWorkers(workers); 
    }
    
  } on DioException catch (e) {
    print("❌ Kullanıcıları yükleme hatası: ${e.response?.data['message'] ?? e.message}");
    if (mounted && e.response?.statusCode != 404) { // 404'ü ignore etme veya ele alma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı listesi yüklenemedi: ${e.response?.statusCode}')),
      );
    }
  } catch (e) {
    print("❌ Genel yükleme hatası: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ağ bağlantısı hatası.')),
      );
    }
  }
}


String roleLabel(BuildContext context, String role) {
  switch (role) {
    case 'Admin':
      return AppLocalizations.of(context)?.statusManagement ?? 'Yönetim';
    case 'Purchasing':
      return AppLocalizations.of(context)?.statusPurchasing ?? 'Satın Alma Birimi';
    case 'ProductionPlanner':
      return AppLocalizations.of(context)?.statusProductPlanning ?? 'Ürün Planlama Sorumlusu';
    case 'Foreman':
      return AppLocalizations.of(context)?.statusForeman ?? 'Ustabaşı';
    case 'Worker':
      return AppLocalizations.of(context)?.statusCraftsman ?? 'Usta';
    default:
      return role; // bilinmeyen rol gelirse en azından kodu göster
  }
}


  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      body: Directionality(
        textDirection: isArabic ? TextDirection.ltr : Directionality.of(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)?.searchHint ?? 'Search by phone/name',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 11, 26, 94)),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 11, 26, 94), width: 1.5)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 11, 26, 94), width: 2)),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<AuthCubit>().searchWorker(value),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => context.read<AuthCubit>().searchWorker(searchController.text.trim()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) return const Center(child: CircularProgressIndicator());
                  if (state is AuthLoaded) {
                    final workers = state.workers;
                    if (workers.isEmpty) return Center(child: Text(AppLocalizations.of(context)?.noRecords ?? 'No records found'));
                    return ListView.builder(
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return WorkerListItem(worker: worker);
                      },
                    );
                  }
                  return Center(child: Text(AppLocalizations.of(context)?.errorOccurred ?? 'An error occurred'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
