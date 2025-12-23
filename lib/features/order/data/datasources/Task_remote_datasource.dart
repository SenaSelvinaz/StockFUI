// lib/features/order/data/datasources/task_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/stage_model.dart';

abstract class TaskRemoteDataSource {
  Future<TaskAssignmentResultModel> bulkAssignTasks(
    BulkTaskAssignmentModel assignment,
  );
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSourceImpl({required this.dio});

  @override
  Future<TaskAssignmentResultModel> bulkAssignTasks(
    BulkTaskAssignmentModel assignment,
  ) async {
    final response = await dio.post(
      '/tasks/bulk-assign',
      data: assignment.toJson(),
    );
    return TaskAssignmentResultModel.fromJson(response.data);
  }
}
