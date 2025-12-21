import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/worker.dart';
import '../cubit/auth_cubit.dart';
import 'package:dio/dio.dart'; // Dio için

import 'package:flinder_app/core/services/api_service.dart';



class EditWorkerPage extends StatefulWidget {
  final Worker worker;
  final String originalPhone; // eski telefon

  const EditWorkerPage({super.key, required this.worker, required this.originalPhone});

  @override
  State<EditWorkerPage> createState() => _EditWorkerPageState();
}

class _EditWorkerPageState extends State<EditWorkerPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  String? selectedStatus;


  @override
  void initState() {

    super.initState();
    nameController = TextEditingController(text: widget.worker.name);

    
    phoneController= TextEditingController(
      text:widget.worker.phone,
    );
    selectedStatus=widget.worker.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bilgileri Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Ad Soyad"),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              items: const [
                DropdownMenuItem(value: "Worker", child: Text("Usta")),
                DropdownMenuItem(value: "Foreman", child: Text("Ustabaşı")),
                DropdownMenuItem(
                    value: "ProductionPlanner",
                    child: Text("Ürün Planlama Sorumlusu")),
                DropdownMenuItem(
                    value: "Purchasing", child: Text("Satın Alma Birimi")),
                DropdownMenuItem(
                    value: "Admin", child: Text("Yönetim")),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
              decoration: const InputDecoration(labelText: "Statü"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: phoneController,
              keyboardType:TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefon Numarası",
                prefixText: "+",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                _saveUpdatedWorker();
              },
              child: const Text(
                "Güncelle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _saveUpdatedWorker() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final status = selectedStatus;

    if (name.isEmpty || phone.isEmpty || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları doldurun")));
      return;
    }

    if (!isValidTurkishPhone(phone)) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Geçersiz telefon numarası")));
       return;
    }

    //final fullPhone="+90 $phone";

    final updated = Worker(
      name: name, 
      phone: phone, 
      role: status);
      _updateWorkerToApi(updated);

    //context.read<AuthCubit>().updateWorker(updated, widget.originalPhone);
    //Navigator.pop(context, updated);
  }


  bool isValidTurkishPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 12 ;
    //&& digits.startsWith('5');
  }



  //----------------------------
  Future<void> _updateWorkerToApi(Worker updatedWorker) async {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Güncelleme yapılıyor...")),
  );

  try {
    // 1️⃣ Telefon değişmiş mi?
    if (updatedWorker.phone != widget.originalPhone) {
      await ApiService.put(
        "/api/admin/update-phone",
        data: {
          "oldPhoneNumber": "${widget.originalPhone}",
          "newPhoneNumber": "${updatedWorker.phone}",
        },
      );
    }

    // 2️⃣ İsim + Departman güncelle
    //final parts = updatedWorker.name.split(" ");
    final parts = updatedWorker.name.trim().split(RegExp(r'\s+'));

    final firstName = parts.first;
    final lastName =
    parts.length > 1 ? parts.sublist(1).join(" ") : "";


    await ApiService.put(
      "/api/admin/update-worker",
      data: {
        "PhoneNumber": "${updatedWorker.phone}",
        //"FirstName": parts.first,
        //"LastName": parts.length > 1 ? parts.last : "",
        "FirstName": firstName,
        "LastName": lastName,

        "Department": updatedWorker.role,
      },
    );

    // 3️⃣ Local listeyi güncelle
    context.read<AuthCubit>().updateWorker(
      updatedWorker,
      widget.originalPhone,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Güncelleme başarılı")),
    );

    Navigator.pop(context, updatedWorker);

  } on DioException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.response?.data?['message'] ?? "API hatası")),
    );
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Beklenmeyen hata oluştu")),
    );
  }
}

  





}