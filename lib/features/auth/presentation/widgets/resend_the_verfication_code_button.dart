import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/OTP_code_verfication.dart';

class ResendTheVerficationCodeButton extends StatelessWidget {
  const ResendTheVerficationCodeButton({
    super.key,
    required this.widget,
  });

  final OTPCodeVerfication widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topLeft,
      child: TextButton(
        onPressed: () {
          context.read<ForgetPasswordCubit>().forgotPasswordRequest(
            email: widget.email,
          );
        },
        child: Text(
          "Resend the code",
          style: AppTextStyles.bodySmall!.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
