import 'dart:async';
import 'package:flinder_app/features/login/domain/usecases/resend_otp_usecase.dart';
import 'package:flinder_app/features/login/domain/usecases/send_otp_usecase.dart';
import 'package:flinder_app/features/login/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flinder_app/features/login/presentation/cubit/login_state.dart';
import 'package:flinder_app/core/services/dio_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  Timer? _resendTimer;

  LoginCubit({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(LoginInitial());

  Future<void> sendOtp(String phoneNumber) async {
    try {
      emit(LoginLoading());

      final result = await sendOtpUseCase.call(phoneNumber);

      if (result.success) {
        emit(OtpSent(phoneNumber: phoneNumber, message: result.message));
        _startResendCountdown();
      } else {
        emit(LoginError(message: result.message));
      }
    } catch (e) {
      emit(LoginError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// 2. SMS kodunu doğrula ve giriş yap
  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      emit(LoginLoading());

      final user = await verifyOtpUseCase.call(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
      );

      // Token'ı kaydet
      await DioService.saveToken(user.token);

      //  Kullanıcı bilgisini kaydet (5 role)
      await DioService.saveUser({
        'id': user.id,
        'phoneNumber': user.phoneNumber,
        'name': user.name,
        'email': user.email,
        'role': user.role.toApiString(),
        'department': user.department,
        'position': user.position,
      });

      emit(LoginSuccess(user: user));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(LoginError(message: errorMessage));
    }
  }

  /// 3. SMS kodunu tekrar gönder
  Future<void> resendOtp(String phoneNumber) async {
    try {
      emit(LoginLoading());

      final result = await resendOtpUseCase.call(phoneNumber);

      if (result.success) {
        emit(
          OtpSent(
            phoneNumber: phoneNumber,
            message: 'SMS kodu tekrar gönderildi',
          ),
        );
        _startResendCountdown();
      } else {
        emit(LoginError(message: result.message));
      }
    } catch (e) {
      emit(LoginError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Resend countdown başlat (60 saniye)
  void _startResendCountdown() {
    _resendTimer?.cancel();
    int seconds = 60;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds > 0) {
        emit(OtpResendCountdown(seconds: seconds));
      } else {
        timer.cancel();
        // Countdown bitince OtpSent state'e geri dön
        if (state is OtpSent) {
          emit(state); // Aynı state'i tekrar emit et
        }
      }
    });
  }

  /// Reset state
  void reset() {
    _resendTimer?.cancel();
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
