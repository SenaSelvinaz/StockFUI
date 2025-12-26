import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'package:flinder_app/core/services/dio_service.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/features/production_stages/presentation/widgets/my_tasks_carousel.dart';
import 'package:flinder_app/features/production_stages/data/models/pending_task_card_vm.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int _currentIndex = 0;
  late Future<List<PendingTaskCardVm>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _getWorkerTasks();
  }

  Future<List<PendingTaskCardVm>> _getWorkerTasks() async {
    try {
      final response = await DioService.get('/api/tasks/my');
      if (response.statusCode != 200) return [];

      final raw = response.data;
      debugPrint("TASKS RAW TYPE: ${raw.runtimeType}");
      debugPrint("TASKS RAW: $raw");


      late final List<dynamic> listJson;
      if (raw is List) {
        listJson = raw;
      } else if (raw is Map<String, dynamic>) {
        final maybeList = raw['data'] ?? raw['tasks'] ?? raw['result'];
        if (maybeList is List) {
          listJson = maybeList;
        } else {
          debugPrint("Beklenen liste yok. Keys: ${raw.keys}");
          return [];
        }
      } else {
        debugPrint("Beklenmeyen response tipi: ${raw.runtimeType}");
        return [];
      }

      // Daha sağlam: Map<dynamic,dynamic> gelirse de çalışsın
      return listJson
          .map((e) => PendingTaskCardVm.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      debugPrint("Görevler çekilirken hata oluştu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // TAB 0
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() => _tasksFuture = _getWorkerTasks());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      child: _Header(
                        title: localization?.workerPanel ?? "Usta Paneli",
                        subtitle: localization?.home ?? "Ana Sayfa",
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FutureBuilder<List<PendingTaskCardVm>>(
                        future: _tasksFuture,
                        builder: (context, snapshot) {
                          // Loading
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(title: "  Görevlerim"),
                                const SizedBox(height: 10),
                                const _InfoCard(
                                  icon: Icons.hourglass_top_rounded,
                                  title: "Yükleniyor...",
                                  message: "Görevleriniz getiriliyor.",
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }

                          // Error
                          if (snapshot.hasError) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(title: " Görevlerim"),
                                const SizedBox(height: 10),
                                _InfoCard(
                                  icon: Icons.wifi_off_rounded,
                                  title: "Bağlantı sorunu",
                                  message: "Sunucuya ulaşılamadı. Yenilemeyi deneyin.",
                                  actionText: "Tekrar Dene",
                                  onAction: () => setState(() => _tasksFuture = _getWorkerTasks()),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }

                          final tasks = snapshot.data ?? [];

                          // Empty
                          if (tasks.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(title: " Görevlerim"),
                                const SizedBox(height: 10),
                                const _InfoCard(
                                  icon: Icons.inbox_rounded,
                                  title: "Görev yok",
                                  message: "Şu an üzerinize atanmış görev bulunmuyor.",
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }

                          // Success
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),                              
                              Row(
                                children: [
                                  const Expanded(child: _SectionTitle(title: " Görevlerim")),
                                  _Pill(text: "${tasks.length} görev"),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // Carousel senin widget’ın
                              MyTasksCarousel(
                                tasks: tasks,
                                onTap: (task) {
                                  debugPrint("Tıklanan Görev ID: ${task.taskId}");
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            ),
          ),

          // TAB 1
          const ProfileScreen(),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, -6),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF252644),
          unselectedItemColor: Colors.grey.shade600,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: localization?.home ?? "Ana Sayfa",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: localization?.profile ?? "Profil",
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B1A5E),
            Color(0xFF1C2C86),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.work_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Görevlerinizi buradan takip edin",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),
              ],
            ),
          ),
          const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ],
      ),
    );
  }
}



class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 239, 135, 161),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF111827)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.25),
                ),
                if (actionText != null && onAction != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onAction,
                      child: Text(actionText!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}
