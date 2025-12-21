import 'package:flutter/material.dart';
import 'package:flinder_app/features/auth/domain/entities/worker.dart';

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WorkerCard({
    super.key,
    required this.worker,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solda avatar tipi bir icon
            CircleAvatar(
              radius: 26,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.person,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(width: 14),

            // Bilgiler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Telefon: ${worker.phone}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Statü: ${worker.role}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Sağda düzenle/sil butonları
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blueGrey,
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
