import 'package:flutter/material.dart';
import '../../domain/entities/worker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

import 'package:dio/dio.dart'; // Dio için

import 'package:flinder_app/core/services/api_service.dart';


class AddWorkerPage extends StatefulWidget {
  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedStatus;
  String countryCode = "+90 ";



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ad Soyad

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Çalışanın adını ve soyadını girin"),
            ),
            const SizedBox(height: 12),

            // Statü
            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: "Usta",
                  child: Text("Usta")),
                DropdownMenuItem(
                  value: "Ustabaşı", 
                  child: Text("Ustabaşı")),
                DropdownMenuItem(
                  value: "Ürün Planlama Sorumlusu",
                  child: Text("Ürün Planlama Sorumlusu"),
                ),
                DropdownMenuItem(
                  value: "Satın Alma Birimi",
                  child: Text("Satın Alma Birimi"),
                ),
                DropdownMenuItem(
                  value: "Yönetim",
                  child: Text("Yönetim")),
              ],

              onChanged: (value) => setState(() => selectedStatus = value),

              decoration: const InputDecoration(labelText: "Statü"),

            ),
            const SizedBox(height: 12),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Çalışanın telefon numarasını giriniz",
                hintText: "5xx xxx xx xx",
                prefixText: "$countryCode ", // +90 başlığı
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
            ),
              ),),

            const Spacer(),

            //Kaydetme butonu
            ElevatedButton(
              onPressed:_saveWorker,
              child: const Text(
                "Kaydet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorker(){

    final name = nameController.text;
    final phone =phoneController.text;
    String? status = selectedStatus;

    if (name.isEmpty || phone.isEmpty || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    if (!isValidTurkishPhone(phone)) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Geçersiz telefon numarası. Örn: 5xx xxx xx xx"))
      );
      return;
    }

    //final fullPhone="+90 $phone";


    final worker= Worker(
      name: name,
      phone: phone,
      status: status,
    );

    _showConfirmDialog(worker);
  }


  Future<void> _addWorkerToApi(Worker worker) async {
  // Diyalogu kapat (Kayıt işlemi devam ederken diyalog açık kalmasın)
  Navigator.pop(context); 

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Çalışan kaydediliyor..."), duration: Duration(seconds: 10)),
  );



  final parts = worker.name.trim().split(RegExp(r'\s+'));

  final firstName = parts.first;
  final lastName =
    parts.length > 1 ? parts.sublist(1).join(" ") : "";  
  // Backend'in beklediği JSON formatı:
  final payload = {
    "Phone": "90${worker.phone.replaceAll(' ', '')}", // Örnek: "5301234567" -> "905301234567"
    //"FirstName": worker.name.split(' ').first, // İlk kelimeyi ad olarak al
    //"LastName": worker.name.split(' ').last,   // Son kelimeyi soyad olarak al
    "FirstName":firstName, 
    "LastName": lastName,   
    "Department": worker.status, // Statü/Bölüm adını yolluyoruz (Backend'de Department olarak geçiyordu)
    "Role": "Worker" // Varsayılan rol
  };

  try {
    // API Çağrısı (data: named argument olarak geçildi)
    final response = await ApiService.post(
      "/api/admin/create-worker", 
      data: payload
    );

    // 1. API'den Başarılı Yanıt Geldiyse (Status 200 OK)
    // Bu noktada veri veritabanına kaydedildi ve SMS gönderildi.
    
    // 2. Cubit'e yerel olarak ekle (UI'ı güncellemek için)


    final normalizedWorker = Worker(
  name: worker.name,
  phone: "90${worker.phone.replaceAll(' ', '')}",
  status: worker.status,
);
    context.read<AuthCubit>().addWorker(worker);
    
    // 3. Başarılı geri bildirim ve inputları temizleme
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.data['message'] ?? 'Kayıt başarılı!')),
    );
    _clearInputs();
    
    // 4. Sayfayı kapat (isteğe bağlı)
    // Navigator.pop(context); 

  } on DioException catch (e) {
    // 400 Bad Request veya 401 Unauthorized gibi API hataları
    final errorMsg = e.response?.data?['message'] ?? "API'den hata yanıtı alındı.";
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hata: $errorMsg')),
    );
  } catch (e) {
    // Diğer genel hatalar (Ağ bağlantısı vb.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kayıt sırasında beklenmeyen bir hata oluştu.')),
    );
  }
}

  void _showConfirmDialog(Worker worker) {
    
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: const Text("Kayıt Onayı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ad: ${worker.name}"),
            Text("Statü: ${worker.status}"),
            Text("Telefon: +90 ${worker.phone}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () { 
              //context.read<AuthCubit>().addWorker(worker);
              _addWorkerToApi(worker);
              //Navigator.pop(context);
              //_clearInputs();
            },
            child: const Text("Tamam"),
          ),
        ],
      );
    },
  );
}

  bool isValidTurkishPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 && digits.startsWith('5');
  }
  
  

  void _clearInputs() {
    nameController.clear();
    phoneController.clear();
    selectedStatus = null;
    setState(() {});
  }

}