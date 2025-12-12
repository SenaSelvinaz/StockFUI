import 'package:flutter/material.dart';
import 'record_operation_screen.dart';
import 'stock_control.dart';
import 'profile_screen.dart';

class MainUI extends StatelessWidget {
  const MainUI({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     /* backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        /*title: const Text(
          "Ana Ekran",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),*/
        centerTitle: true,
        backgroundColor: Colors.white, 
        elevation: 1, //  gölge
        automaticallyImplyLeading: false,
      ),*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child:Padding(
                padding: const EdgeInsets.only(bottom: 25.0, top: 5.0),
                child: Text(
                  "Yönetici Paneli",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // İşlem Kartları Listesi
            _buildOperationCard(
              context,
              icon: Icons.edit_note,
              title: "Çalışan Kayıt İşlemleri",
              destination: const RecordOperationsScreen(),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
              
            ),
            const SizedBox(height: 12),
            _buildOperationCard(
              context,
              icon: Icons.inventory,
              title: "Stok Takip",
              destination: const StockControlPage(),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
            ),
            const SizedBox(height: 12),

            _buildOperationCard(
              context,
              icon: Icons.checklist,
              title: "İş Takip",
              // destination: const JobTrackingScreen(), // Gerçek ekranla değiştirilecek
              destination: _buildPlaceholderScreen("İş Takip Ekranı"),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
            ),
            const SizedBox(height: 12),
            _buildOperationCard(
              context,
              icon: Icons.bar_chart,
              title: "İşlem Raporları",
              // destination: const ReportScreen(), // Gerçek ekranla değiştirilecek
              destination: _buildPlaceholderScreen("İşlem Raporları Ekranı"),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar ekleniyor (Attığınız görseldeki gibi)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0, // Ana Sayfa'da olduğumuzu belirtir
        selectedItemColor: const Color.fromARGB(255, 37, 38, 68),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) {
          // Bu kısım Navigasyon barı yönetimi için kullanılacak
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // Yeniden kullanılabilir, şık kart bileşeni
  Widget _buildOperationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
    Color? cardColor,
  }) {
    return Card(
      color: cardColor?? Colors.white,
      elevation: 10, // Kartın havada durma efekti
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Yuvarlatılmış köşeler
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34.0, horizontal: 24.0),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 36,
                color: Colors.white, // Ana renk ile uyumlu ikon rengi
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ekranların henüz hazır olmadığı durumlar için geçici bir Widget
  Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "$title yakında eklenecektir.",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}