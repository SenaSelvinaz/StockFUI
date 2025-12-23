/*
import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;
  
  // Dropdown'daki sabit listeyi buraya taşıdık
  static const List<String> statusOptions = [
    "Usta",
    "Ustabaşı",
    "Ürün Planlama Sorumlusu",
    "Satın Alma Birimi",
  ];

  const StatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Çalışma Statüsü",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Bir statü seçin"),
              value: selectedStatus,
              items: statusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}*/