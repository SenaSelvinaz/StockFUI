import 'package:flutter/material.dart';
import 'record_operation_screen.dart';
import 'stock_control.dart';
import 'profile_screen.dart';
import '/features/auth/presentation/pages/test_page.dart';

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
      body: SafeArea(
      child:SingleChildScrollView(
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

              destination: _buildPlaceholderScreen("İş Takip Ekranı"),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
            ),
            const SizedBox(height: 12),
            _buildOperationCard(
              context,
              icon: Icons.bar_chart,
              title: "İşlem Raporları",
              destination: _buildPlaceholderScreen("İşlem Raporları Ekranı"),
              cardColor: const Color.fromARGB(255, 11, 26, 94),
            ),

                /*_buildOperationCard(
                 context,
                  icon: Icons.cloud_download,
                title: "Backend Test",
                destination: TestPage(), // Buraya TestPage’i bağladık
                cardColor: const Color.fromARGB(255, 11, 26, 94),
                 ),*/

          ],
        ),
      ),
    ),
   
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
        currentIndex: 0, 
        selectedItemColor: const Color.fromARGB(255, 37, 38, 68),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildOperationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
    Color? cardColor,
  }) {
    return Card(
      color: cardColor?? Colors.white,
      elevation: 10, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
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
                color: Colors.white, 
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