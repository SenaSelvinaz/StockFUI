import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flinder_app/core/theme/app_theme.dart';
import 'package:flinder_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flinder_app/features/auth/presentation/pages/edit_worker_page.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/features/auth/domain/entities/worker.dart';// Worker sınıfınızı buradan import edin
class WorkerListItem extends StatelessWidget {
  final Worker worker;
  final Widget? trailing;

  const WorkerListItem({
    super.key,
    required this.worker,
    this.trailing,
  });

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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 28,
            child: Icon(
              Icons.account_circle_outlined,
              size: 40,
              color: Color.fromARGB(255, 11, 26, 94),
            ),
          ),
          title: Align(
            alignment:
                isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              worker.name,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _roleLabel(context, worker.role),
                style:
                    TextStyle(color: AppTheme.secondaryTextColor),
              ),
              Text(
                _formatPhoneForUI(worker.phone),
                style:
                    TextStyle(color: AppTheme.secondaryTextColor),
              ),
            ],
          ),

          // 👇 ESKİ edit butonu aynen duruyor
          trailing: trailing ??
              (context.read<AuthCubit>().isAdmin
                  ? IconButton(
                      icon: const Icon(Icons.edit,
                          color: AppTheme.primaryColor),
                      onPressed: () async {
                        final updatedWorker =
                            await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditWorkerPage(
                              worker: worker,
                              originalPhone: worker.phone,
                            ),
                          ),
                        );

                        if (updatedWorker != null) {
                          context
                              .read<AuthCubit>()
                              .updateWorker(
                                  updatedWorker, worker.phone);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content: Text("Kayıt güncellendi")),
                          );
                        }
                      },
                    )
                  : const SizedBox.shrink()),
        ),
        const Divider(height: 1),
      ],
    );
  }

  String _roleLabel(BuildContext context, String role) {
    switch (role) {
      case 'Admin':
        return AppLocalizations.of(context)?.statusManagement ??
            'Yönetim';
      case 'Purchasing':
        return AppLocalizations.of(context)?.statusPurchasing ??
            'Satın Alma Birimi';
      case 'ProductionPlanner':
        return AppLocalizations.of(context)
                ?.statusProductPlanning ??
            'Ürün Planlama Sorumlusu';
      case 'Foreman':
        return AppLocalizations.of(context)?.statusForeman ??
            'Ustabaşı';
      case 'Worker':
        return AppLocalizations.of(context)?.statusCraftsman ??
            'Usta';
      default:
        return role;
    }
  }
}
