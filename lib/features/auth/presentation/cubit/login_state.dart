import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// İlk durum
class LoginInitial extends LoginState {}

/// Yükleniyor
class LoginLoading extends LoginState {}

/// SMS gönderildi
class OtpSent extends LoginState {
  final String phoneNumber;
  final String message;

  const OtpSent({
    required this.phoneNumber,
    this.message = 'SMS kodu gönderildi',
  });

  @override
  List<Object?> get props => [phoneNumber, message];
}

/// SMS tekrar gönder countdown
class OtpResendCountdown extends LoginState {
  final int seconds;

  const OtpResendCountdown({required this.seconds});

  @override
  List<Object?> get props => [seconds];
}

///  Giriş başarılı (User bilgisi ile)
class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Hata
class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}
