import 'package:flutter/material.dart';
import 'record_operation_screen.dart';

class MainUI extends StatelessWidget {
  const MainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Menü"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Center(
            child: Text(
              "Yönetici Ekranı",
              style: TextStyle(fontSize: 22),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
}
