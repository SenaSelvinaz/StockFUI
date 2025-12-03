import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/workers_data.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../domain/entities/worker.dart';

class AddWorkerPage extends StatefulWidget {
  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedStatus;
  String countryCode = "+90"; // Başlangıçta +90

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Yeni İşçi Kaydı",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AD-SOYAD
            const Text("Adı Soyadı",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "İşçinin adını ve soyadını girin",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// STATÜ
            const Text("Çalışma Statüsü",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Bir statü seçin"),
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: "Usta", child: Text("Usta")),
                    DropdownMenuItem(value: "Ustabaşı", child: Text("Ustabaşı")),
                    DropdownMenuItem(
                        value: "Ürün Planlama Sorumlusu",
                        child: Text("Ürün Planlama Sorumlusu")),
                    DropdownMenuItem(
                        value: "Satın Alma Birimi",
                        child: Text("Satın Alma Birimi")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// TELEFON
            const Text("Telefon Numarası",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "5xx xxx xx xx",
                prefixText: "$countryCode ", // +90 başlığı
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),

            /// KAYDET BUTONU
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String phone = phoneController.text;
                  String? status = selectedStatus;

                  if (name.isEmpty || phone.isEmpty || status == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Lütfen tüm alanları doldurun")),
                    );
                    return;
                  }

                  // Cubit kullanarak ekleme
                  context.read<AuthCubit>().addWorker(
                        Worker(
                          name: name,
                          phone: "$countryCode $phone",
                          status: status,
                        ),
                      );

                  // Başarı mesajı
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Kayıt Başarılı"),
                      content: Text(
                          "Ad Soyad: $name\nTelefon: $countryCode $phone\nStatü: $status"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            nameController.clear();
                            phoneController.clear();
                            selectedStatus = null;
                            setState(() {});
                          },
                          child: const Text("Tamam"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(230, 116, 175, 206),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Kaydet",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
