
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/worker.dart';
import '../cubit/auth_cubit.dart';


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
    selectedStatus=widget.worker.status;
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
                DropdownMenuItem(value: "Usta", child: Text("Usta")),
                DropdownMenuItem(value: "Ustabaşı", child: Text("Ustabaşı")),
                DropdownMenuItem(
                    value: "Ürün Planlama Sorumlusu",
                    child: Text("Ürün Planlama Sorumlusu")),
                DropdownMenuItem(
                    value: "Satın Alma Birimi", child: Text("Satın Alma Birimi")),
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
                prefixText: "+90 ",
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
      status: status);

    context.read<AuthCubit>().updateWorker(updated, widget.originalPhone);
    Navigator.pop(context, updated);
  }


  bool isValidTurkishPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 && digits.startsWith('5');
  }




}
