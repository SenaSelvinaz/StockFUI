import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'edit_worker_page.dart';

class UpdateWorkerPage extends StatefulWidget {
  const UpdateWorkerPage({super.key});

  @override
  State<UpdateWorkerPage> createState() => _UpdateWorkerPageState();
}

class _UpdateWorkerPageState extends State<UpdateWorkerPage> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) {
    context.read<AuthCubit>().searchWorker(query);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch(""); 
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Güncelle"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Çalışan ara (Ad veya Telefon)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _performSearch,
            ),
          ),

          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AuthLoaded) {
                  final workers = state.workers;

                  if (workers.isEmpty) {
                    final message = _searchController.text.isNotEmpty
                        ? "Aradığınız kritere uygun çalışan bulunamadı."
                        : "Güncellenecek kayıt bulunmamaktadır.";
                    return Center(child: Text(message));
                  }

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (_, index) {
                      final worker = workers[index];

                      return ListTile(
                        title: Text(worker.name),
                        subtitle: Text("+90 ${worker.phone}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 11, 26, 94)),
                          onPressed: () async { 
                            final originalPhone = worker.phone; 

                            final updatedWorker = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditWorkerPage(
                                  worker: worker,
                                  originalPhone: originalPhone, // worker ın orijinal telefon numarasını gönder
                                ), 
                              ),
                            );

                            if (updatedWorker != null){
                              context.read<AuthCubit>().updateWorker(updatedWorker, originalPhone);

                              _performSearch(_searchController.text); 

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Kayıt güncellendi")),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text("Kayıt bulunamadı"));
              },
            ),
          ),
        ],
      ),
    );
  }
}