import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:dio/dio.dart'; // Dio için
import '../../domain/entities/worker.dart';
import 'package:flinder_app/core/services/api_service.dart';

class DeleteWorkerPage extends StatefulWidget {
  const DeleteWorkerPage({super.key});

  @override
  State<DeleteWorkerPage> createState() => _DeleteWorkerPageState();
}

class _DeleteWorkerPageState extends State<DeleteWorkerPage> {
  final TextEditingController searchController = TextEditingController();

   String _formatPhoneForUI(String phone) {
    if (phone.startsWith('90') && phone.length == 12) {
      return "+90 ${phone.substring(2, 5)} "
             "${phone.substring(5, 8)} "
             "${phone.substring(8, 10)} "
             "${phone.substring(10)}";
    }
    return phone;
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
                      labelText: "Telefon numarası/ad soyad ile ara",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 11, 26, 94)
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
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<AuthCubit>().searchWorker(
                          searchController.text.trim(),
                        );
                  },
                ),
              ],
            ),
          ),

          // LİSTE
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {

                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AuthLoaded) {
                  final workers = state.workers;

                  if (workers.isEmpty) {
                    return const Center(child: Text("Kayıt bulunamadı"));
                  }

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (_, index) {
                      final worker = workers[index];

                      return ListTile(
                        title: Text(worker.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_formatPhoneForUI(worker.phone),),
                            Text(worker.status),
                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, worker);
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text("Bir hata oluştu"));
              },
            ),
          ),
        ],
      ),
    );
  }

  // _DeleteWorkerPageState sınıfı içinde, örneğin _confirmDelete metodundan hemen sonra

// ✅ YENİ: Backend'den silme (pasif hale getirme) işlemini yapan fonksiyon
Future<void> _deleteWorkerFromApi(BuildContext context, Worker worker) async {
  // Diyalogu kapat (İşlem devam ederken diyalog açık kalmasın)
  Navigator.pop(context);

  // Telefon numarasını backend'in beklediği formata hazırlayın.
  // Backend'de {phoneNumber} parametresi kullanıldığı için sadece numara yeterli.
  //final phoneWithoutCountryCode = worker.phone.replaceAll(' ', '');
  final phoneWithoutCountryCode = worker.phone
    .replaceAll('+', '')
    .replaceAll(' ', '');
    //.replaceFirst('90', '');


  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Kayıt siliniyor..."), duration: Duration(seconds: 3)),
  );
  
  try {

    print("DELETE GİDEN NUMARA: $phoneWithoutCountryCode");

    // API Çağrısı: DELETE /api/admin/delete-user/{phoneNumber}
    // Örnek: DELETE /api/admin/delete-user/5301234567
    final response = await ApiService.delete(
      "/api/admin/delete-user/$phoneWithoutCountryCode",
    );

    // 1. API'den Başarılı Yanıt Geldiyse (Status 200 OK)
    
    // 2. Cubit'e yerel olarak silme işlemini yap (UI'ı güncellemek için)
    // Cubit, silme işlemi için 'phone' bekliyor
    context.read<AuthCubit>().deleteWorker(worker.phone); 
    
    // 3. Başarılı geri bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.data['message'] ?? 'Çalışan başarıyla silindi.')),
    );

  } on DioException catch (e) {
    // Hata geri bildirimi
    final errorMsg = e.response?.data?['message'] ?? "Silme işlemi sırasında bir hata oluştu.";
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hata: $errorMsg')),
    );
  } catch (e) {
    // Genel hata (Ağ bağlantısı vb.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Beklenmeyen bir hata oluştu.')),
    );
  }
}
  void _confirmDelete(BuildContext context, worker) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Silme Onayı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ad: ${worker.name}"),
            Text("Telefon: +${worker.phone}"),
            Text("Statü: ${worker.status}"),
            const SizedBox(height: 12),
            const Text(
              "Bu kişiyi silmek istediğinize emin misiniz?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),

          TextButton(
            onPressed: () {
              //context.read<AuthCubit>().deleteWorker(worker.phone);

              //Navigator.pop(context);
              _deleteWorkerFromApi(context, worker);

              /*ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kayıt silindi")),
              );*/
            },
            child: const Text("Evet, Sil"),
          ),
        ],
      ),
    );
  }
}
