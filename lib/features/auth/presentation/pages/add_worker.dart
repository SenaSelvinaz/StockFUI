import 'package:flutter/material.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/features/auth/domain/entities/worker.dart';
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

  String? selectedRole;

  String countryCode = "+90 ";



  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isAdmin = context.read<AuthCubit>().isAdmin;

    if (!isAdmin) {
      return Scaffold(
        body: Center(child: Text(AppLocalizations.of(context)?.onlyAdmins ?? 'Only admins can perform this action.')),
      );
    }

    return Scaffold(
      body: Directionality(
        textDirection: isArabic ? TextDirection.ltr : Directionality.of(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.enterWorkerName ?? "Enter worker's full name",
                    hintText: AppLocalizations.of(context)?.namePlaceholder ?? 'Example User',
                    border: const OutlineInputBorder(),
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.enterPhone ?? "Enter worker's phone number",
                    hintText: AppLocalizations.of(context)?.phoneHint ?? '5xx xxx xx xx',
                    border: const OutlineInputBorder(),
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  items: [
                    DropdownMenuItem(
                      value: 'Admin', 
                      child: Text(AppLocalizations.of(context)?.statusManagement ?? 'Yönetim')),
                    DropdownMenuItem(
                      value: 'Purchasing', 
                      child: Text(AppLocalizations.of(context)?.statusPurchasing ?? 'Satın Alma Birimi')),
                    DropdownMenuItem(
                      value: 'ProductionPlanner', 
                      child: Text(AppLocalizations.of(context)?.statusProductPlanning ?? 'Ürün Planlama Sorumlusu')),
                    DropdownMenuItem(
                      value: 'Foreman', 
                      child: Text(AppLocalizations.of(context)?.statusForeman ?? 'Ustabaşı')),
                    DropdownMenuItem(
                      value: 'Worker', 
                      child: Text(AppLocalizations.of(context)?.statusCraftsman ?? 'Usta')),
                    
                  ],
                  onChanged: (v) => setState(() => selectedRole = v),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.status ?? 'Status',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveWorker,
                        child: Text(AppLocalizations.of(context)?.save ?? 'Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveWorker(){

    final name = nameController.text;
    final phone =phoneController.text;
    String? role = selectedRole;

    if (name.isEmpty || phone.isEmpty || role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.fillAllFields ?? 'Please fill all fields')),
      );
      return;
    }

    if (!isValidTurkishPhone(phone)) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.invalidPhone ?? 'Invalid phone number'))
      );
      return;
    }

    //final fullPhone="+90 $phone";


    final worker= Worker(
      name: name,
      phone: phone,
      role: role
    );

    _showConfirmDialog(worker);
  }


  Future<void> _addWorkerToApi(Worker worker) async {
  // Diyalogu kapat (Kayıt işlemi devam ederken diyalog açık kalmasın)
  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context)?.savingWorker ?? 'Saving worker...'), duration: const Duration(seconds: 10)),
  );



  final parts = worker.name.trim().split(RegExp(r'\s+'));

  final firstName = parts.first;
  final lastName =
    parts.length > 1 ? parts.sublist(1).join(" ") : "";

  // Map status code to Turkish label for backend 'Department' field (always Turkish regardless of UI locale)
  const Map<String, String> _turkishStatus = {
    'Admin': 'Yönetim',
    'Purchasing': 'Satın Alma Birimi',
    'ProductionPlanner': 'Ürün Planlama Sorumlusu',
    'Worker': 'Usta',
    'Foreman': 'Ustabaşı',
  };

  final departmentLabel = _turkishStatus[worker.role] ?? worker.role;

  // Backend'in beklediği JSON formatı:
  final payload = {
    "Phone": "90${worker.phone.replaceAll(' ', '')}", // Örnek: "5301234567" -> "905301234567"
    "FirstName": firstName,
    "LastName": lastName,
    //"Department": departmentLabel, // Statü/Bölüm adını yolluyoruz (Backend'de Department olarak geçiyordu)
    "Role":worker.role // Varsayılan rol
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
      role: worker.role,
    );

    if (!mounted) return;

    context.read<AuthCubit>().addWorker(normalizedWorker);

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
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $errorMsg')),
      );
    }
  } catch (e) {
    // Diğer genel hatalar (Ağ bağlantısı vb.)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt sırasında beklenmeyen bir hata oluştu.')),
      );
    }
  }
}

  String _localizedStatusLabel(String? status, BuildContext context) {
    switch (status) {
      case 'Admin':
        return AppLocalizations.of(context)?.statusManagement ?? 'Yönetim';
      case 'Purchasing':
        return AppLocalizations.of(context)?.statusPurchasing ?? 'Satın Alma Birimi';
      case 'ProductionPlanner':
        return AppLocalizations.of(context)?.statusProductPlanning ?? 'Ürün Planlama Sorumlusu';
      case 'Worker':
        return AppLocalizations.of(context)?.statusCraftsman ?? 'Usta';
      case 'Foreman':
        return AppLocalizations.of(context)?.statusForeman ?? 'Ustabaşı';
      default:
        return status ?? '';
    }
  }

  void _showConfirmDialog(Worker worker) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.confirmSaveTitle ?? 'Save Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(context)?.workerNameLabel ?? 'Name'}: ${worker.name}'),
              Text('${AppLocalizations.of(context)?.phoneNumber ?? 'Phone'}: +90 ${worker.phone}'),
              Text('${AppLocalizations.of(context)?.role ?? 'Role'}: ${_localizedStatusLabel(worker.role, context)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addWorkerToApi(worker);
              },
              child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
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
    selectedRole = null;
    setState(() {});
  }

}