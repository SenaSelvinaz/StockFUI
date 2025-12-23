import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// using built-in TextField instead of pin_code_fields
import 'package:flinder_app/core/constants/app_colors.dart';
import 'package:flinder_app/core/constants/app_strings.dart';
import 'package:flinder_app/core/di/injection_container.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class OtpVerificationPage extends StatelessWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
      child: OtpVerificationView(phoneNumber: phoneNumber),
    );
  }
}

class OtpVerificationView extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationView({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final _otpController = TextEditingController();
  String _currentOtp = '';

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_currentOtp.length == 6) {
      context.read<LoginCubit>().verifyOtp(widget.phoneNumber, _currentOtp);
    }
  }

  String _formatPhoneNumber(String phone) {
    // +905xxxxxxx -> +90 5** *** 12 34
    if (phone.length >= 13) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 4)}** *** ${phone.substring(9, 11)} ${phone.substring(11, 13)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Giriş başarılı!'),
                backgroundColor: Colors.green,
              ),
            );
            // Ana sayfaya yönlendirme yapılabilir
          }
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final resendSeconds = state is OtpResendCountdown ? state.seconds : 0;
          final canResend = resendSeconds == 0;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    AppStrings.otpTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle with phone number
                  Text(
                    '${_formatPhoneNumber(widget.phoneNumber)} numaralı telefona\ngönderilen 6 haneli kodu giriniz.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 48),

                  // PIN Code Input (replaced with built-in TextField)
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentOtp = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Resend OTP
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.otpResendPrefix,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: canResend
                              ? () {
                                  context.read<LoginCubit>().resendOtp(
                                    widget.phoneNumber,
                                  );
                                }
                              : null,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.otpResendButton,
                            style: TextStyle(
                              color: canResend
                                  ? AppColors.link
                                  : AppColors.textHint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!canResend) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(00:${resendSeconds.toString().padLeft(2, '0')})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),

                  // Verify Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          (state is LoginLoading || _currentOtp.length != 6)
                          ? null
                          : _handleVerify,
                      child: state is LoginLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(AppStrings.verifyButton),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Test Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Test Kodu: 123456',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
