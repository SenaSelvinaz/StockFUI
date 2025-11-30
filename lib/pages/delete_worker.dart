import 'package:flutter/material.dart';
import '../data/workers_data.dart';

class DeleteWorker extends StatefulWidget {
  const DeleteWorker({super.key});

  @override
  State<DeleteWorker> createState()=> _DeleteWorkerState();
}
class _DeleteWorkerState extends State<DeleteWorker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Sil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: workersList.isEmpty
          ? const Center(
              child: Text("Hiç kayıt yok"),
            )
          : ListView.builder(
              itemCount: workersList.length,
              itemBuilder: (context, index) {
                final worker = workersList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(worker["name"]!),
                    subtitle: Text(
                        "Telefon: ${worker["phone"]}\nStatü: ${worker["status"]}"),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Silme işlemi
                        setState(() {
                          workersList.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kayıt silindi")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
