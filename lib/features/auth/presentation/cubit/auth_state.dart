import '../../domain/entities/worker.dart';
import '../../data/models/current_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final List<Worker> workers;
  AuthLoaded(this.workers);
}
// ✅ Profil için
class AuthMeLoading extends AuthState {}

class AuthMeLoaded extends AuthState {
  final CurrentUser user;
  AuthMeLoaded(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

