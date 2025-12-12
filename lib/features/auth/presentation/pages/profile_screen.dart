import 'package:flutter/material.dart';
import 'main_ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'Türkçe';
  final List<String> _languages = ['Türkçe', 'English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Profilim",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _buildProfileContent(context),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
        currentIndex: 1, // PROFIL sayfasında olduğumuzun göstergesi
        selectedItemColor: const Color.fromARGB(255, 37, 38, 68),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Ana sayfaya geri dön
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainUI()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- PROFIL KARTI ---
        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 45),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Ad Soyad (Örnek Kullanıcı)",
                    style: TextStyle(fontSize: 20, 
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                  ),
                ),
                const Divider(height: 30),
                _buildDetailRow(Icons.phone, "Telefon Numarası", "******"),
                _buildDetailRow(Icons.badge, "Yetki Düzeyi", "Yönetici"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        // --- AYARLAR ---
        Text(
          "Uygulama Ayarları",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        const Divider(height: 10),

        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: [
                    Icon(Icons.language, color: Color.fromARGB(255, 255, 255, 255), size: 24),
                    SizedBox(width: 15),
                    Text("Dil Seçimi", style: 
                    TextStyle(fontSize: 16,
                    color: Colors.white,
                    ),),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Dil değiştirildi: $newValue")),
                      );
                    });
                  },
                  items: _languages.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        // ÇIKIŞ 
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Çıkış Yap"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade400),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
