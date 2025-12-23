import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:dio/dio.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import '../../domain/entities/worker.dart';
import 'package:flinder_app/core/services/api_service.dart';
import '../widgets/worker_list_item.dart';

class DeleteWorkerPage extends StatefulWidget {
  const DeleteWorkerPage({super.key});

  @override
  State<DeleteWorkerPage> createState() => _DeleteWorkerPageState();
}

class _DeleteWorkerPageState extends State<DeleteWorkerPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAndLoadWorkers();
  }

  Future<void> _fetchAndLoadWorkers() async {
    try {
      final response = await ApiService.get("/api/admin/users");
      final List rawWorkers = response.data['data'] ?? [];

      final List<Worker> workers = rawWorkers.map((item) {
        final String phoneNumber =
            (item['phoneNumber'] as String? ?? '').replaceAll(' ', '');

        return Worker(
          name: item['fullName'] ?? 'İsimsiz',
          phone: phoneNumber.replaceAll(' ', ''),
          role: item['role'] ?? 'Worker',
        );
      }).toList();

      if (mounted) {
        context.read<AuthCubit>().loadWorkers(workers);
      }
    } on DioException catch (e) {
      if (mounted && e.response?.statusCode != 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kullanıcı listesi yüklenemedi: ${e.response?.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ağ bağlantısı hatası.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Directionality(
        textDirection:
            isArabic ? TextDirection.ltr : Directionality.of(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textAlign:
                          isArabic ? TextAlign.right : TextAlign.left,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)?.searchHint ??
                                'Search by phone/name',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 26, 94),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 26, 94),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<AuthCubit>().searchWorker(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      context
                          .read<AuthCubit>()
                          .searchWorker(searchController.text.trim());
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (state is AuthLoaded) {
                    final workers = state.workers;

                    if (workers.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)?.noRecords ??
                              'No records found',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return WorkerListItem(
                          worker: worker,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color:  Color.fromARGB(255, 11, 26, 94)),
                            onPressed: () {
                              _confirmDelete(context, worker);
                            },
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: Text(
                      AppLocalizations.of(context)?.errorOccurred ??
                          'An error occurred',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _roleLabel(BuildContext context, String role) {
  switch (role) {
    case 'Admin':
      return AppLocalizations.of(context)?.statusManagement ?? 'Yönetim';
    case 'Purchasing':
      return AppLocalizations.of(context)?.statusPurchasing ?? 'Satın Alma Birimi';
    case 'ProductionPlanner':
      return AppLocalizations.of(context)?.statusProductPlanning ?? 'Ürün Planlama';
    case 'Foreman':
      return AppLocalizations.of(context)?.statusForeman ?? 'Ustabaşı';
    case 'Worker':
      return AppLocalizations.of(context)?.statusCraftsman ?? 'Usta';
    default:
      return role;
  }
}


  Future<void> _deleteWorkerFromApi(
      BuildContext context, Worker worker) async {
    Navigator.pop(context);

    final phoneWithoutCountryCode = worker.phone
        .replaceAll('+', '')
        .replaceAll(' ', '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.deleting ??
              'Deleting record...',
        ),
      ),
    );

    try {
      final response = await ApiService.delete(
        "/api/admin/delete-user/$phoneWithoutCountryCode",
      );

      context.read<AuthCubit>().deleteWorker(worker.phone);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(response.data['message'] ?? 'Çalışan silindi'),
        ),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data?['message'] ??
                'Silme sırasında hata oluştu',
          ),
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, Worker worker) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.deleteConfirmTitle ??
              'Delete Confirmation',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)?.workerNameLabel ?? 'Adı Soyadı'}: ${worker.name}'),
            Text('${AppLocalizations.of(context)?.phoneNumber ?? 'Telefon'}: +${worker.phone}'),
            Text('${AppLocalizations.of(context)?.role ?? 'Rol'}: ${_roleLabel(context, worker.role)}'),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)?.deleteConfirmMessage ??
                  'Are you sure?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)?.cancel ?? 'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteWorkerFromApi(context, worker);
            },
            child: Text(
              AppLocalizations.of(context)?.yesDelete ??
                  'Yes, Delete',
            ),
          ),
        ],
      ),
    );
  }
}
