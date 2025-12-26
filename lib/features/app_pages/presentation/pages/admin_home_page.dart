import 'package:flutter/material.dart';
//import 'stock_control.dart';
import 'profile_screen.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/features/production_stages/presentation/pages/production_records_page/product_tracking_screen.dart';

import 'package:flinder_app/features/auth/presentation/pages/record_operations_page/record_operation_screen.dart';
import 'package:flinder_app/features/auth/presentation/pages/stock_control_screen.dart';



class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final localization = AppLocalizations.of(context);

    return Scaffold(
  body: IndexedStack(
    index: _currentIndex,
    children: [
      // TAB 0 → Admin ana sayfa
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Directionality(
            textDirection: isArabic
                ? TextDirection.ltr
                : Directionality.of(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0, top: 5.0),
                    child: Text(
                      localization?.managerPanel ?? 'Manager Panel',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                _buildOperationCard(
                  context,
                  icon: Icons.edit_note,
                  title: localization?.recordOperations ?? 'Record Operations',
                  destination: const RecordOperationsScreen(),
                  cardColor: const Color.fromARGB(255, 11, 26, 94),
                ),
                const SizedBox(height: 12),

                _buildOperationCard(
                  context,
                  icon: Icons.inventory,
                  title: localization?.stockControl ?? 'Stock Control',
                  destination: const StockControlPage(),
                  cardColor: const Color.fromARGB(255, 11, 26, 94),
                ),
                const SizedBox(height: 12),

                _buildOperationCard(
                  context,
                  icon: Icons.checklist,
                  title: localization?.jobTracking ?? 'Job Tracking',
                  destination: ProductionTrackingScreen(),
                  cardColor: const Color.fromARGB(255, 11, 26, 94),
                ),
              ],
            ),
          ),
        ),
      ),

      // TAB 1 → PROFİL
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

  Widget _buildOperationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
    Color? cardColor,
  }) {
    return Card(
      color: cardColor ?? Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34.0, horizontal: 24.0),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(width: 25),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderScreen(BuildContext context, String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Text(
          AppLocalizations.of(context)?.comingSoon(title) ??
              '$title will be added soon.',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
