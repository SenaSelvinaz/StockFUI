import 'package:flutter/material.dart';
import 'add_worker.dart';
import 'delete_worker.dart';
import 'record_operations_screen.dart';

class mainUI extends StatelessWidget {
  const mainUI({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Menü"),
        centerTitle: true,
      ),

      // BODY
      body: Stack(
        children: [
          // Sayfa içeriği buraya
          const Center(
            child: Text(
              "Hoş Geldiniz!",
              style: TextStyle(fontSize: 22),
            ),
          ),

          // ALT ORTADA BUTON
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecordOperationsScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Kayıt İşlemleri",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecordOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Yeni Kayıt"),
              onTap: () {
                Navigator.pop(context);  // alt menüyü kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddWorker()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Kayıt Sil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DeleteWorker()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
