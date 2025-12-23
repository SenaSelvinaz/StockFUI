// lib/features/order/presentation/pages/order_page_backend_integrated.dart

import 'package:flinder_app/features/order/presentation/widgets/selection_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';
import '../widgets/quantity_input_widget.dart';
import '../widgets/bom_check_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _notesController = TextEditingController();

  // ✅ Backend için gerekli değişkenler
  int? _selectedProductId;
  String? _selectedProductCode;
  String? _selectedProductName;
  String? _selectedProductDescription;

  int _quantity = 1; // Minimum 1
  String _selectedPriority = 'Normal';
  DateTime _selectedDate = DateTime.now();
  String _selectedAssigneeId = '';
  String _selectedAssigneeName = '';

  // ✨ BOM Check için
  bool _showBomCheck = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ✨ Ürün seçim dialog'u - BACKEND ENTEGRE
  Future<void> _showProductSelectionDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ProductSelectionDialog(),
    );

    if (result != null) {
      setState(() {
        _selectedProductId = result['id'];
        _selectedProductCode = result['code'];
        _selectedProductName = result['name'];
        _selectedProductDescription = result['description'];
        _showBomCheck = false; // Yeni ürün seçilince BOM'u temizle
      });
    }
  }

  // ✨ Ustabaşı seçim dialog'u - BACKEND ENTEGRE
  Future<void> _showAssigneeSelectionDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const UserSelectionDialog(role: 'Foreman'),
    );

    if (result != null) {
      setState(() {
        _selectedAssigneeId = result['value']; // Guid
        _selectedAssigneeName = result['label'];
      });
    }
  }

  // ✨ BOM Kontrolü
  void _checkBomAvailability() {
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce bir ürün seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir miktar girin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _showBomCheck = true);

    context.read<OrderCubit>().checkBomAvailability(
      productId: _selectedProductId!,
      quantity: _quantity,
    );
  }

  void _createOrder() {
    // Validasyonlar
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir ürün seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir miktar girin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedAssigneeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen ustabaşı seçin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Order Entity oluştur
    final order = OrderEntity(
      productId: _selectedProductId!,
      quantity: _quantity,
      priority: _selectedPriority,
      deliveryDate: _selectedDate,
      assignedToUserId: _selectedAssigneeId,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    context.read<OrderCubit>().createOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sipariş #${state.order.id} başarıyla oluşturuldu'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is OrderApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is OrderApprovalFailed) {
          _showStockInsufficientDialog(state);
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is OrderLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D1F)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Sipariş Oluştur',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFE8EBED)),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductSelector(),
                    const SizedBox(height: 24),
                    if (_selectedProductId != null) ...[
                      _buildProductInfo(),
                      const SizedBox(height: 24),
                      _buildOrderInfoSection(),
                      const SizedBox(height: 24),
                      _buildBomCheckButton(state),
                      const SizedBox(height: 24),
                      if (_showBomCheck) _buildBomCheckResults(state),
                      if (_showBomCheck) const SizedBox(height: 24),
                      _buildAssigneeSection(),
                      const SizedBox(height: 24),
                      _buildNotesSection(),
                      const SizedBox(height: 24),
                      _buildOrderSummary(),
                      const SizedBox(height: 100),
                    ],
                  ],
                ),
              ),
              if (_selectedProductId != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildCreateOrderButton(isLoading, state),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBomCheckButton(OrderState state) {
    final isChecking = state is BomCheckLoading;

    return Material(
      color: const Color(0xFF2196F3).withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isChecking ? null : _checkBomAvailability,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isChecking ? Icons.hourglass_empty : Icons.checklist_rtl,
                  color: const Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isChecking
                          ? 'Kontrol ediliyor...'
                          : 'Reçete (BOM) Kontrolü Yap',
                      style: const TextStyle(
                        color: Color(0xFF1A1D1F),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gerekli malzemelerin stok durumunu kontrol et',
                      style: TextStyle(
                        color: const Color(0xFF6C7275).withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isChecking)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF2196F3)),
                  ),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF2196F3),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBomCheckResults(OrderState state) {
    if (state is BomCheckLoading) {
      return const BomCheckWidget(bomCheckResult: null, isLoading: true);
    }

    if (state is BomCheckLoaded) {
      return BomCheckWidget(
        bomCheckResult: state.result,
        onRefresh: _checkBomAvailability,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildProductSelector() {
    return InkWell(
      onTap: _showProductSelectionDialog,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedProductId == null
                ? const Color(0xFFFF6B6B)
                : const Color(0xFFE8EBED),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedProductId != null
                    ? const Color(0xFF2196F3).withOpacity(0.1)
                    : const Color(0xFFFF6B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2,
                color: _selectedProductId != null
                    ? const Color(0xFF2196F3)
                    : const Color(0xFFFF6B6B),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedProductName ?? 'Ürün Seçin',
                style: TextStyle(
                  color: _selectedProductName != null
                      ? const Color(0xFF1A1D1F)
                      : const Color(0xFF9BA1A6),
                  fontSize: 16,
                  fontWeight: _selectedProductName != null
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9BA1A6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedProductName ?? '',
                  style: const TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_selectedProductCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _selectedProductCode!,
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (_selectedProductDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              _selectedProductDescription!,
              style: const TextStyle(
                color: Color(0xFF6C7275),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Sipariş Bilgileri',
            style: TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          QuantityInputWidget(
            initialValue: _quantity,
            onChanged: (value) {
              setState(() {
                _quantity = value;
                if (_showBomCheck) {
                  _showBomCheck = false;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE8EBED), height: 1),
          const SizedBox(height: 16),
          _buildPrioritySelector(),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE8EBED), height: 1),
          const SizedBox(height: 16),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        const Text(
          'Öncelik',
          style: TextStyle(
            color: Color(0xFF6C7275),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE8EBED)),
          ),
          child: DropdownButton<String>(
            value: _selectedPriority,
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6C7275)),
            style: const TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            items: ['Düşük', 'Normal', 'Yüksek'].map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: priority == 'Yüksek'
                            ? const Color(0xFFFF6B6B)
                            : priority == 'Normal'
                            ? const Color(0xFF2196F3)
                            : const Color(0xFF9BA1A6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(priority),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedPriority = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        const Text(
          'Termin Tarihi',
          style: TextStyle(
            color: Color(0xFF6C7275),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Material(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF2196F3),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Color(0xFF1A1D1F),
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8EBED)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF2196F3),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    style: const TextStyle(
                      color: Color(0xFF1A1D1F),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssigneeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Ustabaşı Atama',
            style: TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _showAssigneeSelectionDialog,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedAssigneeId.isEmpty
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFFE8EBED),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedAssigneeId.isNotEmpty
                          ? const Color(0xFF2196F3).withOpacity(0.1)
                          : const Color(0xFFFF6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: _selectedAssigneeId.isNotEmpty
                          ? const Color(0xFF2196F3)
                          : const Color(0xFFFF6B6B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedAssigneeId.isNotEmpty
                          ? _selectedAssigneeName
                          : 'Ustabaşı Seçin',
                      style: TextStyle(
                        color: _selectedAssigneeId.isNotEmpty
                            ? const Color(0xFF1A1D1F)
                            : const Color(0xFF9BA1A6),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9BA1A6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Notlar (Opsiyonel)',
            style: TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Sipariş hakkında not ekleyin...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE8EBED)),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Sipariş Özeti',
            style: TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem('Ürün', _selectedProductCode ?? 'N/A'),
          _buildSummaryItem('Adet', '$_quantity Adet'),
          _buildSummaryItem('Öncelik', _selectedPriority),
          _buildSummaryItem(
            'Termin',
            '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
          ),
          _buildSummaryItem(
            'Ustabaşı',
            _selectedAssigneeName.isNotEmpty
                ? _selectedAssigneeName
                : 'Belirtilmedi',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFE8EBED), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF6C7275), fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateOrderButton(bool isLoading, OrderState state) {
    bool canCreate = true;
    if (state is BomCheckLoaded && !state.result.isSufficient) {
      canCreate = false;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: canCreate ? const Color(0xFF2196F3) : const Color(0xFF9BA1A6),
          borderRadius: BorderRadius.circular(12),
          elevation: 0,
          child: InkWell(
            onTap: (isLoading || !canCreate) ? null : _createOrder,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          canCreate ? Icons.assignment_turned_in : Icons.block,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          canCreate ? 'SİPARİŞ OLUŞTUR' : 'STOK YETERSİZ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showStockInsufficientDialog(OrderApprovalFailed state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
            SizedBox(width: 12),
            Text('Stok Yetersiz'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            const Text(
              'Eksik Malzemeler:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...state.insufficientItems.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• ${item.itemName}: ${item.missing} adet eksik'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
