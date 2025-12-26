import 'package:flinder_app/features/production_stages/presentation/pages/production_records_page/delikleme_gorevi_page.dart';
import 'package:flinder_app/features/production_stages/presentation/pages/production_records_page/kesim_gorevi_page.dart';
import 'package:flinder_app/features/production_stages/presentation/pages/production_records_page/paketleme_gorevi_page.dart';
import 'package:flutter/material.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'kaynak_gorevi_page.dart';

class ProductionTrackingScreen extends StatelessWidget {
  const ProductionTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.jobTracking ?? 'Production Tracking',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2, // 🔥 2 sütun
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: 1, // 🔥 Kare
          children: [
            _buildGridItem(
              context,
              icon: Icons.cut,
              title: AppLocalizations.of(context)?.cutting ?? 'Cutting',
              onTap: () {
                 Navigator.push(
                 context,
                   MaterialPageRoute(
                      builder: (context) => const KesimGoreviPage(),
                  ),
                  );
                // Navigator.push(...)
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.circle_outlined,
              title: AppLocalizations.of(context)?.drilling ?? 'Drilling',
              onTap: () {
                 Navigator.push(
                 context,
                   MaterialPageRoute(
                      builder: (context) => const DeliklemeGoreviPage(),
                ),
                  );
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.inventory_2,
              title: AppLocalizations.of(context)?.packaging ?? 'Packaging',
              onTap: () {
                
                Navigator.push(
                 context,
                   MaterialPageRoute(
                      builder: (context) => const PaketlemeGoreviPage(),
                ),
                  );
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.construction,
              title: AppLocalizations.of(context)?.welding ?? 'Welding',
              onTap: () {
                Navigator.push(
                 context,
                   MaterialPageRoute(
                      builder: (context) => const KaynakGoreviPage(),
                ),
                  );
                
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 11, 26, 94),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
