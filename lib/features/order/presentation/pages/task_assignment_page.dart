// lib/features/order/presentation/pages/task_assignment_page.dart

import 'package:flinder_app/features/order/data/datasources/Task_remote_datasource.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/stage_entity.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/models/stage_model.dart';
import '../widgets/selection_dialogs.dart';
import 'package:flinder_app/core/services/dio_service.dart';

/// Ustabaşının siparişin aşamalarına usta atadığı sayfa
class TaskAssignmentPage extends StatefulWidget {
  final OrderEntity order;

  const TaskAssignmentPage({super.key, required this.order});

  @override
  State<TaskAssignmentPage> createState() => _TaskAssignmentPageState();
}

class _TaskAssignmentPageState extends State<TaskAssignmentPage> {
  final _orderDataSource = OrderRemoteDataSourceImpl(dio: DioService.dio);
  final _taskDataSource = TaskRemoteDataSourceImpl(dio: DioService.dio);

  bool _isLoading = true;
  String? _error;

  OrderStageAssignmentEntity? _stageData;
  final Map<int, StageAssignment> _assignments = {};

  @override
  void initState() {
    super.initState();
    _loadStages();
  }

  Future<void> _loadStages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stages = await _orderDataSource.getOrderStagesForAssignment(
        widget.order.id!,
      );

      setState(() {
        _stageData = stages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectWorkerForStage(StageEntity stage) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const UserSelectionDialog(role: 'Worker'),
    );

    if (result != null) {
      setState(() {
        _assignments[stage.stageId] = StageAssignment(
          stageId: stage.stageId,
          workerId: result['value'],
          workerName: result['label'],
        );
      });
    }
  }

  Future<void> _submitAssignments() async {
    if (_assignments.length != _stageData!.totalStages) {
      _showSnackBar(
        'Lütfen tüm aşamalara usta atayın',
        const Color(0xFFFFA726),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final assignmentModel = BulkTaskAssignmentModel(
        orderId: widget.order.id!,
        assignments: _assignments.values.toList(),
      );

      final result = await _taskDataSource.bulkAssignTasks(assignmentModel);

      if (!mounted) return;

      if (result.success) {
        _showSnackBar(result.message, const Color(0xFF4CAF50));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _showSnackBar(result.message, const Color(0xFFFF6B6B));
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Hata: $e', const Color(0xFFFF6B6B));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError()
          : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D1F)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Sipariş Aşamaları',
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
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 16),
          Text(_error ?? 'Bir hata oluştu'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadStages,
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_stageData == null) return const SizedBox.shrink();

    final allAssigned = _assignments.length == _stageData!.totalStages;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.order.priority == 'Yüksek') ...[
                _buildPriorityBanner(),
                const SizedBox(height: 16),
              ],
              _buildOrderInfo(),
              const SizedBox(height: 16),
              _buildMaterialStatus(),
              const SizedBox(height: 24),
              if (_stageData!.suntaStages.isNotEmpty) ...[
                _buildSectionTitle('SUNTA İŞLEMLERİ', Icons.view_module),
                const SizedBox(height: 12),
                ..._stageData!.suntaStages.map(_buildStageCard),
                const SizedBox(height: 16),
              ],
              if (_stageData!.profilStages.isNotEmpty) ...[
                _buildSectionTitle('PROFİL İŞLEMLERİ', Icons.straighten),
                const SizedBox(height: 12),
                ..._stageData!.profilStages.map(_buildStageCard),
                const SizedBox(height: 16),
              ],
              if (_stageData!.finalStages.isNotEmpty) ...[
                _buildSectionTitle('SON İŞLEMLER', Icons.inventory),
                const SizedBox(height: 12),
                ..._stageData!.finalStages.map(_buildStageCard),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomButton(allAssigned),
        ),
      ],
    );
  }

  Widget _buildPriorityBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B6B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'YÜKSEK ÖNCELİK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
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
              const Text(
                'Sipariş Kodu',
                style: TextStyle(
                  color: Color(0xFF6C7275),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                _stageData?.orderCode ?? 'N/A',
                style: const TextStyle(
                  color: Color(0xFF1A1D1F),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE8EBED), height: 1),
          const SizedBox(height: 12),
          const Text(
            'Ürün',
            style: TextStyle(
              color: Color(0xFF6C7275),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_stageData?.productName ?? widget.order.productName} – ${_stageData?.quantity ?? widget.order.quantity} adet',
            style: const TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE8EBED), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Öncelik',
                      style: TextStyle(
                        color: Color(0xFF6C7275),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.order.priority == 'Yüksek'
                            ? const Color(0xFFFF6B6B).withOpacity(0.1)
                            : const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.order.priority,
                        style: TextStyle(
                          color: widget.order.priority == 'Yüksek'
                              ? const Color(0xFFFF6B6B)
                              : const Color(0xFF2196F3),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Termin Tarihi',
                      style: TextStyle(
                        color: Color(0xFF6C7275),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.order.deliveryDate.day}.${widget.order.deliveryDate.month}.${widget.order.deliveryDate.year}',
                      style: const TextStyle(
                        color: Color(0xFF1A1D1F),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialStatus() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
          SizedBox(width: 10),
          Text(
            'Malzeme yeterli',
            style: TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C7275), size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6C7275),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStageCard(StageEntity stage) {
    final assignment = _assignments[stage.stageId];
    final isAssigned = assignment != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAssigned ? const Color(0xFF2196F3) : const Color(0xFFE8EBED),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isAssigned
                      ? const Color(0xFF2196F3).withOpacity(0.1)
                      : const Color(0xFF9BA1A6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAssigned ? Icons.check : Icons.radio_button_unchecked,
                  color: isAssigned
                      ? const Color(0xFF2196F3)
                      : const Color(0xFF9BA1A6),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stage.stageName,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1F),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isAssigned)
            _buildAssignedWorkerInfo(assignment)
          else
            _buildWorkerSelector(stage),
        ],
      ),
    );
  }

  Widget _buildAssignedWorkerInfo(StageAssignment assignment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.person, color: Color(0xFF2196F3), size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              assignment.workerName ?? 'Usta',
              style: const TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            color: const Color(0xFF2196F3),
            onPressed: () => _selectWorkerForStage(
              _stageData!.allStages.firstWhere(
                (s) => s.stageId == assignment.stageId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerSelector(StageEntity stage) {
    return InkWell(
      onTap: () => _selectWorkerForStage(stage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8EBED)),
        ),
        child: const Row(
          children: [
            Icon(Icons.person_add, color: Color(0xFF6C7275), size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Usta Seç',
                style: TextStyle(
                  color: Color(0xFF6C7275),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF6C7275), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(bool allAssigned) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!allAssigned)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFFA726).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Color(0xFFFFA726),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${_assignments.length}/${_stageData!.totalStages} aşama atandı. Devam etmek için tüm aşamaları atayın.',
                        style: const TextStyle(
                          color: Color(0xFFFFA726),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Material(
              color: allAssigned
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF9BA1A6),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: allAssigned ? _submitAssignments : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        allAssigned ? Icons.check_circle : Icons.block,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        allAssigned
                            ? 'DAĞIT VE BAŞLAT'
                            : 'TÜM AŞAMALARI ATAYINIZ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
