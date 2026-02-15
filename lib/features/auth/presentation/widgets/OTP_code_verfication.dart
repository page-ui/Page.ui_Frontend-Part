import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/presentation/widgets/verify_o_t_p_widget.dart';

class OTPCodeVerfication extends StatefulWidget {
  const OTPCodeVerfication({
    super.key,
    required this.controllers,
    required this.nextStep,
    required this.email,
  });
  final List<TextEditingController> controllers;
  final void Function() nextStep;
  final String email;
  @override
  State<OTPCodeVerfication> createState() => _OTPCodeVerficationState();
}

class _OTPCodeVerficationState extends State<OTPCodeVerfication> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKeyCodeVerify = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyCodeVerify,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          const Text(
            "VERIFY OTP",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 22,
              letterSpacing: 1.5,
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "ENTER THE 5-DIGIT CODE SENT TO YOU",
            style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
          ),
          const SizedBox(height: 24),

          VerifyOTPWidget(controllers: widget.controllers),
          const SizedBox(height: 30),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Resend the code",
                style: AppTextStyles.bodySmall!.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          CustomButton(
            title: "VERIFY",
            onPressed: () {
              for (var controller in widget.controllers) {
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
                showWebSnackBar(context: context, message: 'OTP Verified.');
                formKeyCodeVerify.currentState!.reset();
                widget.nextStep();
              } else {
                setState(() {
                  autovalidateMode = AutovalidateMode.always;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
