import 'package:flutter/material.dart';
import 'package:flinder_app/features/production_stages/data/models/pending_task_card_vm.dart';

class MyTasksCarousel extends StatelessWidget {
  final List<PendingTaskCardVm> tasks;
  final void Function(PendingTaskCardVm task)? onTap;

  const MyTasksCarousel({
    super.key,
    required this.tasks,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const _EmptyTasks();

    return SizedBox(
      height: 210,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.90),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final t = tasks[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == tasks.length - 1 ? 0 : 12,
            ),
            child: _TaskCard(task: t, onTap: onTap),
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final PendingTaskCardVm task;
  final void Function(PendingTaskCardVm task)? onTap;

  const _TaskCard({required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap == null ? null : () => onTap!(task),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Color(0x0A000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: order code + small chevron
              Row(
                children: [
                  _Chip(
                    icon: Icons.receipt_long_rounded,
                    text: task.orderCode,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                task.productName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              _InfoRow(
                icon: Icons.build_circle_outlined,
                label: "Atanan İşlem",
                value: task.processType.label,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.confirmation_number_outlined,
                label: "İşlem adedi",
                value: "${task.processQty}",
                valueBold: true,
              ),

              const Spacer(),

              // Bottom row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 18, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text(
                      "Sipariş miktarı:",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${task.orderedQty}",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool valueBold;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        const SizedBox(width: 10),
        SizedBox(
          width: 95,
          child: Text(
            "$label:",
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: valueBold ? FontWeight.w800 : FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF374151)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x0A000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.inbox_rounded, color: Color(0xFF111827)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Bekleyen görev yok 🎉\nYeni görev atanınca burada göreceksin.",
              style: TextStyle(
                height: 1.25,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
