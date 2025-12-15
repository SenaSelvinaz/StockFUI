import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flinder_app/core/theme/app_theme.dart';
import 'package:flinder_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flinder_app/features/auth/presentation/pages/edit_worker_page.dart';
import '../../domain/entities/worker.dart'; // Worker sınıfınızı buradan import edin

class WorkerListItem extends StatelessWidget {

  final Worker worker;
  
  const WorkerListItem({super.key, required this.worker});

    // 📱 Telefonu UI için formatla: 905XXXXXXXXX -> +90 5XX XXX XX XX
  String _formatPhoneForUI(String phone) {
    if (phone.startsWith('90') && phone.length == 12) {
      return "+90 ${phone.substring(2, 5)} "
             "${phone.substring(5, 8)} "
             "${phone.substring(8, 10)} "
             "${phone.substring(10)}";
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius:28,
            child: Icon(
              Icons.account_circle_outlined,
              size:40,
              color:Color.fromARGB(255, 11, 26, 94),
            ),           
          ),

          title: Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold)),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                worker.status, 
                style: TextStyle(color: AppTheme.secondaryTextColor),
              ),
               Text(_formatPhoneForUI(worker.phone), 
                style: TextStyle(color: AppTheme.secondaryTextColor),
              ),
            ],
          ),
        
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
             onPressed: () async {
              final updatedWorker= await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(_) => EditWorkerPage(
                            worker: worker,
                            originalPhone: worker.phone,
                            ), 
                        ),
                      );

                      if (updatedWorker != null){

                        context.read<AuthCubit>().updateWorker(updatedWorker ,worker.phone);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kayıt güncellendi")),
                        );
                      }

            },
          ),
        ),
        const Divider(height: 1),
      ],
    );

    
  }
}