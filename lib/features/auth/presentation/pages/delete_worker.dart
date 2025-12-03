import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../domain/entities/worker.dart';

String formatPhone(String phone) {
  String number = phone.replaceAll('+90', '').replaceAll(' ', '');
  
  if (number.length != 10) return phone; // 10 hane değilse olduğu gibi bırak

  return '+90 ${number.substring(0,3)} ${number.substring(3,6)} ${number.substring(6,8)} ${number.substring(8,10)}';
}

class DeleteWorkerPage extends StatelessWidget {
  const DeleteWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Sil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          List<Worker> workers = [];
          if (state is AuthLoaded) {
            workers = state.workers;
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workers.isEmpty) {
            return const Center(child: Text("Kayıtlı işçi yok"));
          }

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (_, index) {
              final worker = workers[index];
              return ListTile(
                title: Text(worker.name),
                //subtitle: Text("${worker.status} - ${worker.phone}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatPhone(worker.phone)),
                    Text(worker.status),     
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Cubit üzerinden silme
                    context.read<AuthCubit>().deleteWorker(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kayıt silindi")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
