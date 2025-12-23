// lib/features/order/presentation/widgets/bom_check_widget.dart

import 'package:flutter/material.dart';
import '../../domain/entities/bom_check_result_entity.dart';

class BomCheckWidget extends StatelessWidget {
  final BomCheckResultEntity? bomCheckResult;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const BomCheckWidget({
    super.key,
    required this.bomCheckResult,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (bomCheckResult == null) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFE8EBED)),
          if (!bomCheckResult!.isSufficient) ...[
            _buildMaterialsList(),
            const Divider(height: 1, color: Color(0xFFE8EBED)),
          ],
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final result = bomCheckResult!;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (result.isSufficient) {
      statusColor = const Color(0xFF4CAF50);
      statusIcon = Icons.check_circle;
      statusText = 'Stok Yeterli';
    } else {
      statusColor = const Color(0xFFFF6B6B);
      statusIcon = Icons.error;
      statusText = 'Stok Yetersiz';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reçete (BOM) Kontrolü',
                  style: TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.isSufficient
                      ? 'Tüm malzemeler mevcut'
                      : '${result.insufficientItems.length} malzeme eksik',
                  style: const TextStyle(
                    color: Color(0xFF6C7275),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    final items = bomCheckResult!.insufficientItems;

    return Column(
      children: [
        // Header Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Malzeme Adı',
                  style: TextStyle(
                    color: Color(0xFF6C7275),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Gerekli',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6C7275),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Mevcut',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6C7275),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: const Text(
                  'Durum',
                  style: TextStyle(
                    color: Color(0xFF6C7275),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Material Rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: Color(0xFFE8EBED),
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            return _buildMaterialRow(items[index]);
          },
        ),
      ],
    );
  }

  Widget _buildMaterialRow(InsufficientItemEntity item) {
    Color statusColor;
    IconData statusIcon;

    if (item.hasPartial) {
      // Kısmi stok var (turuncu uyarı)
      statusColor = const Color(0xFFFFA726);
      statusIcon = Icons.warning;
    } else if (item.isUnavailable) {
      // Hiç stok yok (kırmızı)
      statusColor = const Color(0xFFFF6B6B);
      statusIcon = Icons.cancel;
    } else {
      // Bu duruma gelmemeli ama fallback
      statusColor = const Color(0xFFFF6B6B);
      statusIcon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Malzeme Adı
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.itemCode,
                  style: const TextStyle(
                    color: Color(0xFF9BA1A6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Gerekli
          Expanded(
            flex: 2,
            child: Text(
              '${item.required} adet',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6C7275), fontSize: 14),
            ),
          ),
          // Mevcut
          Expanded(
            flex: 2,
            child: Text(
              '${item.available} adet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Durum İkonu
          SizedBox(
            width: 60,
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final result = bomCheckResult!;
    final isSufficient = result.isSufficient;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSufficient
            ? const Color(0xFF4CAF50).withOpacity(0.05)
            : const Color(0xFFFF6B6B).withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            isSufficient ? Icons.check_circle_outline : Icons.error_outline,
            color: isSufficient
                ? const Color(0xFF4CAF50)
                : const Color(0xFFFF6B6B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.message ??
                  (isSufficient
                      ? 'Stok durumu otomatik kontrol edildi.'
                      : 'Eksik malzemeler için satın alma talebi oluşturulmalı.'),
              style: TextStyle(
                color: isSufficient
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF6B6B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              color: const Color(0xFF6C7275),
              iconSize: 20,
              onPressed: onRefresh,
              tooltip: 'Yenile',
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Reçete kontrol ediliyor...',
            style: TextStyle(color: Color(0xFF6C7275), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBED)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Color(0xFF9BA1A6),
          ),
          const SizedBox(height: 16),
          const Text(
            'Reçete kontrolü yapılmadı',
            style: TextStyle(
              color: Color(0xFF6C7275),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stok durumunu kontrol etmek için\n"BOM Kontrolü Yap" butonuna basın',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9BA1A6),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Örnek kullanım için demo widget
class BomCheckDemo extends StatelessWidget {
  const BomCheckDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - Yetersiz stok durumu
    final mockInsufficientResult = BomCheckResultEntity(
      isSufficient: false,
      message: 'Sipariş oluşturulamaz. Lütfen eksik malzemeleri temin edin.',
      insufficientItems: const [
        InsufficientItemEntity(
          itemCode: 'SL-100',
          itemName: 'Sunta Levha',
          required: 100,
          available: 150,
          missing: 0,
        ),
        InsufficientItemEntity(
          itemCode: 'PD-50',
          itemName: 'Profil Demiri',
          required: 50,
          available: 45,
          missing: 5,
        ),
        InsufficientItemEntity(
          itemCode: 'PVC-200',
          itemName: 'PVC Kenar Bantı',
          required: 200,
          available: 0,
          missing: 200,
        ),
      ],
    );

    // Mock data - Yeterli stok durumu
    const mockSufficientResult = BomCheckResultEntity(
      isSufficient: true,
      message: 'Tüm malzemeler stokta mevcut.',
      insufficientItems: [],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'BOM Kontrol Demo',
          style: TextStyle(
            color: Color(0xFF1A1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yetersiz Stok Durumu',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            BomCheckWidget(
              bomCheckResult: mockInsufficientResult,
              onRefresh: () {
                print('Refreshing BOM check...');
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Yeterli Stok Durumu',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            BomCheckWidget(
              bomCheckResult: mockSufficientResult,
              onRefresh: () {
                print('Refreshing BOM check...');
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Yükleniyor Durumu',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const BomCheckWidget(bomCheckResult: null, isLoading: true),
            const SizedBox(height: 32),
            const Text(
              'Boş Durum',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const BomCheckWidget(bomCheckResult: null),
          ],
        ),
      ),
    );
  }
}
