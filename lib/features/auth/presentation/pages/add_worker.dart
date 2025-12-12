import 'package:flutter/material.dart';
import '../../domain/entities/worker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';


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
            /// Ad Soyad

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Çalışanın adını ve soyadını girin"),
            ),
            const SizedBox(height: 12),

            /// Statü
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

  void _showConfirmDialog(Worker worker) {
    
  showDialog(
    context: context,
    barrierDismissible: false, // dışarı basınca kapanmasın
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
              context.read<AuthCubit>().addWorker(worker);
              Navigator.pop(context);
              _clearInputs();
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