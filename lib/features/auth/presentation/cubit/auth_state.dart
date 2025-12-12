import '../../domain/entities/worker.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final List<Worker> workers;
  AuthLoaded(this.workers);


}

