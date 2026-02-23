import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/domain/params/verify_reset_code_params.dart';
import 'package:pageui/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/verify_o_t_p_widget.dart';

class OTPCodeVerficationForTheView extends StatefulWidget {
  const OTPCodeVerficationForTheView({super.key, required this.email});

  final String email;
  @override
  State<OTPCodeVerficationForTheView> createState() => _OTPCodeVerficationForTheViewState();
}

class _OTPCodeVerficationForTheViewState extends State<OTPCodeVerficationForTheView> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKeyCodeVerify = GlobalKey<FormState>();
  bool isLoading = false;
  List<TextEditingController> controllers = [];

  void initState() {
    super.initState();
    controllers = List.generate(5, (_) => TextEditingController());
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text = const Text(
      "VERIFY OTP",
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 22,
        letterSpacing: 1.5,
        overflow: TextOverflow.clip,
      ),
    );
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordVerficationCodeSuccess) {
          setState(() {
            isLoading = false;
          });
          showWebSnackBar(context: context, message: 'OTP Verified.');
        } else if (state is ForgetPasswordFailure) {
          setState(() {
            isLoading = false;
          });
          showWebSnackBar(
            context: context,
            message: state.message,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
          );
        } else if (state is ForgetPasswordLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Form(
        key: formKeyCodeVerify,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            text,
            const SizedBox(height: 8),
            const Text(
              "ENTER THE 5-DIGIT CODE SENT TO YOU",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
            ),
            const SizedBox(height: 24),

            VerifyOTPWidget(controllers: controllers),
            const SizedBox(height: 30),
            ResendTheVerficationCodeButton(widget: widget),

            SizedBox(height: 8),
            CustomButton(
              title: "VERIFY",
              onPressed: () {
                for (var controller in controllers) {
                  if (controller.text.isEmpty) {
                    showWebSnackBar(
                      context: context,
                      message: 'OTP not completed.',
                      backgroundColor: AppColors.red,
                      textColor: AppColors.white,
                    );
                    return;
                  }
                }
                if (formKeyCodeVerify.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  context.read<ForgetPasswordCubit>().verifyResetCode(
                    params: VerifyResetCodeParams(
                      email: widget.email,
                      code: controllers.map((e) => e.text).join(),
                    ),
                  );
                  formKeyCodeVerify.currentState!.reset();
                } else {
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
            SizedBox(height: 8),
            Align(
              alignment: AlignmentGeometry.bottomLeft,
              child: Text(
                "Note: email maybe in spam emails.",
                style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResendTheVerficationCodeButton extends StatefulWidget {
  const ResendTheVerficationCodeButton({super.key, required this.widget});

  final OTPCodeVerficationForTheView widget;

  @override
  State<ResendTheVerficationCodeButton> createState() =>
      _ResendTheVerficationCodeButtonState();
}

class _ResendTheVerficationCodeButtonState
    extends State<ResendTheVerficationCodeButton> {
  Timer? _timer;
  bool _isDisabled = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  int _secondsRemaining = 120;

  void _startTimer() {
    _isDisabled = true;
    _secondsRemaining = 120;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isDisabled = false;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: _isDisabled
            ? null
            : () {
                context.read<ForgetPasswordCubit>().forgotPasswordRequest(
                  email: widget.widget.email,
                );
                _startTimer();
              },
        child: Text(
          _isDisabled ? "Resend in $_formattedTime" : "Resend the code",
          style: AppTextStyles.bodySmall!.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
