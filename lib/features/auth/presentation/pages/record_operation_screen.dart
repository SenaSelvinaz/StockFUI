import 'package:flinder_app/features/auth/presentation/pages/stock_control.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                  MaterialPageRoute(builder: (_) => const StockControlPage()),
                );
              },
              child: const Text("Stok Kontrol"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddWorkerPage()),
                );
              },
              child: const Text("Yeni Kayıt Ekle"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteWorkerPage()),
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
