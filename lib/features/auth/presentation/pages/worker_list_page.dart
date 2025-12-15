import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/worker_list_item.dart';
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

       // String cleanedPhone = phoneNumber;
       /* if (cleanedPhone.startsWith('90')) {
        // 90'ı kaldırıp, sadece 10 haneli kısmı bırakıyoruz
        cleanedPhone = cleanedPhone.substring(2).replaceAll(' ', ''); 
       }*/
      
        return Worker(
            /*name: item['FullName'] ?? 'İsimsiz',
            // Telefon numarasını temizliyoruz (backend'de +90 yoktu, frontend'de ekleriz)
            phone: (item['PhoneNumber'] as String).replaceAll('+90', '').replaceAll(' ', ''), 
            status: item['Department'] ?? 'Belirsiz', // Backend'de Department idi*/

            name: item['fullName'] ?? 'İsimsiz', // FullName null ise 'İsimsiz' ata.
            //phone: cleanedPhone, // Artık null olmadığından eminiz
            phone: phoneNumber.replaceAll(' ', ''), // 905XXXXXXXXX,
            status: item['department'] ?? 'Belirsiz', // Department null ise 'Belirsiz' ata.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Telefon numarası/ad soyad ile ara 5xx xxxxxxx",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 11, 26, 94),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 11, 26, 94), 
                          width: 1.5,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 11, 26, 94),
                          width: 2,
                        ),
                      ),
                      
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (value){
                      context.read<AuthCubit>().searchWorker(value);
                    },
                  ),
                ),

                IconButton(
                  onPressed: () {
                    context.read<AuthCubit>().searchWorker(
                      searchController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AuthLoaded) {
                  final workers = state.workers;

                  if (workers.isEmpty) {
                    return const Center(
                      child: Text("Aradığınız kritere uygun çalışan bulunamadı."),
                    );
                  }

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (context, index) {
                      final worker = workers[index];
                      return WorkerListItem(worker: worker);
                    },
                  );
                }

                return const Center(
                  child: Text("Çalışan listesi yüklenirken bir hata oluştu."),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
