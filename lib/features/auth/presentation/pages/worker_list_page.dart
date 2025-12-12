import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/worker_list_item.dart';

class WorkerListPage extends StatefulWidget {
  const WorkerListPage({super.key});

  @override
  State<WorkerListPage> createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
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
                        color: Color.fromARGB(255, 11, 26, 94),
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
                  onPressed: () {
                    context.read<AuthCubit>().searchWorker(
                      searchController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
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
                    return const Center(
                      child: Text("Henüz kayıtlı çalışan bulunmamaktadır."),
                    );
                  }

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (context, index) {
                      final worker = workers[index];
                      return WorkerListItem(worker: worker);
                    },
                  );
                }

                return const Center(
                  child: Text("Çalışan listesi yüklenirken bir hata oluştu."),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
