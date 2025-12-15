import 'package:flutter/material.dart';
import 'package:flinder_app/core/services/api_service.dart';
import 'package:dio/dio.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
  try {
    Response response = await ApiService.get("/api/admin/users");
    setState(() {
      users = response.data['data'] ?? [];
    });
    debugPrint("🔥 Backend cevap verdi:");
    debugPrint(users.toString());
  } catch (e) {
    debugPrint("❌ HATA:");
    debugPrint(e.toString());
  }
}
// ✅ BU, _TestPageState SINIFI İÇİNDEKİ DOĞRU YERDİR
  void _createWorker() async {
    // ⚠️ DİKKAT: Her testte farklı bir telefon numarası kullanın!
    var dummyData = {
      "Phone": "5301234569", // Önceki testten farklı bir numara kullanın (5301234568 yerine 5301234569 gibi)
      "FirstName": "Yetkisiz", 
      "LastName": "Testçi",
      "Department": "Ar-Ge",
      "Role": "Worker" 
    };
    
    try {
      // 🟢 Too many positional arguments HATASININ ÇÖZÜMÜ: data: kullanarak named argument olarak geçiyoruz.
      Response response = await ApiService.post(
          "/api/admin/create-worker", 
          data: dummyData // BURAYI DÜZELTTİK
      );
      
      debugPrint("✅ Çalışan (Yetkisiz) başarıyla oluşturuldu.");
      debugPrint("API Mesajı: ${response.data['message']}");
      
      // Yeni kullanıcıyı görmek için listeyi yenile
      _fetchUsers(); 

    } catch (e) {
       debugPrint("❌ Çalışan oluşturma HATASI: $e");
    }
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Test Users")),
    body: users.isEmpty
        ? Center(child: Text("Kullanıcı yok veya yükleniyor..."))
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index] as Map<String, dynamic>? ?? {};
              return ListTile(
                title: Text(user['FullName'] ?? "İsim yok"),
                subtitle: Text(user['PhoneNumber'] ?? "Telefon yok"),
              );
            },
          ),
  );
}
}
