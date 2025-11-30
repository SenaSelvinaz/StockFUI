import 'package:flutter/material.dart';
import 'add_worker.dart';
import 'delete_worker.dart';

class RecordOperationsScreen extends StatelessWidget {
  const RecordOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt İşlemleri"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);   // Geri → Ana Ekran
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddWorker()),
                );
              },
              child: const Text("Yeni Kayıt Ekle"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteWorker()),
                );
              },
              child: const Text("Kayıt Sil"),
            ),
          ],
        ),
      ),
    );
  }
}
