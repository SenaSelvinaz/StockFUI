import 'package:deneme_test/data/workers_data.dart';
import 'package:flutter/material.dart';

// StatefulWidget
class AddWorker extends StatefulWidget {
  const AddWorker({super.key});

  @override
  State<AddWorker> createState() => _AddWorkerState();
}


class _AddWorkerState extends State<AddWorker> {
  // TextField controllerları
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedStatus; // Dropdown seçilen değeri tutacak


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4), // Arka plan rengi
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

      // BODY
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
            const SizedBox(height: 16),
            Container(
              width: 379.4,
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Bir statü seçin"),
                  value: selectedStatus, // seçilen değeri buraya veriyoruz
                  items: const [
                    DropdownMenuItem(value: "Usta", child: Text("Usta")),
                    DropdownMenuItem(value: "Ustabaşı", child: Text("Ustabaşı")),
                    DropdownMenuItem(value: "Ürün Planlama Sorumlusu", child: Text("Ürün Planlama Sorumlusu")),
                    DropdownMenuItem(value: "Satın Alma Birimi", child: Text("Satın Alma Birimi")),
                    //DropdownMenuItem(value: "Yönetici", child: Text("Yönetici")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value; // seçimi güncelle
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
              controller:phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "(5xx) xxx xx xx",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const Spacer(),

            /// BUTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String name=nameController.text;
                  String phone = phoneController.text;
                  String? status = selectedStatus;

                  // Basit validation (tüm alanlar dolu mu)
                  if (name.isEmpty || phone.isEmpty || status == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
                    );
                    return;
                  }
                  workersList.add({
                    "name":name,
                    "phone":phone,
                    "status":status,
                  });

                  //bilgileri göster
                  showDialog(context: context,
                   builder: (context)=> AlertDialog(
                    title: const Text("Kayıt Başarılı"),
                     content: Text(
                      "Ad Soyad: $name\n"
                      "Telefon: $phone\n"
                      "Statü: $status",
                     ),
                     actions: [
                      TextButton(onPressed: (){
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
                  backgroundColor: const Color.fromARGB(230, 116, 175, 206), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Kaydet",
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.white,      
                    fontWeight: FontWeight.bold, 
                  ),
               ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
