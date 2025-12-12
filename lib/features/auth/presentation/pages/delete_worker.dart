import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class DeleteWorkerPage extends StatefulWidget {
  const DeleteWorkerPage({super.key});

  @override
  State<DeleteWorkerPage> createState() => _DeleteWorkerPageState();
}

class _DeleteWorkerPageState extends State<DeleteWorkerPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Telefon numarası ile ara",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 11, 26, 94)
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 11, 26, 94), 
                          width: 1.5,
                        ),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 11, 26, 94),
                          width: 2,
                        ),
                      ),

                      border: OutlineInputBorder(),
                    ),

                     onChanged: (value){
                      context.read<AuthCubit>().searchWorker(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<AuthCubit>().searchWorker(
                          searchController.text.trim(),
                        );
                  },
                ),
              ],
            ),
          ),

          // LİSTE
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {

                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AuthLoaded) {
                  final workers = state.workers;

                  if (workers.isEmpty) {
                    return const Center(child: Text("Kayıt bulunamadı"));
                  }

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (_, index) {
                      final worker = workers[index];

                      return ListTile(
                        title: Text(worker.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("+90 "+worker.phone),
                            Text(worker.status),
                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, worker);
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text("Bir hata oluştu"));
              },
            ),
          ),
        ],
      ),
    );
  }

  
  void _confirmDelete(BuildContext context, worker) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Silme Onayı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ad: ${worker.name}"),
            Text("Telefon: +90 ${worker.phone}"),
            Text("Statü: ${worker.status}"),
            const SizedBox(height: 12),
            const Text(
              "Bu kişiyi silmek istediğinize emin misiniz?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),

          TextButton(
            onPressed: () {
              context.read<AuthCubit>().deleteWorker(worker.phone);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kayıt silindi")),
              );
            },
            child: const Text("Evet, Sil"),
          ),
        ],
      ),
    );
  }
}
