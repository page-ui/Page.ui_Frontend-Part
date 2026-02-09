import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/core/custom_widget/logo_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/login_view_form.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 180.0),
          child: Column(
            children: [
              LogoWidget(),

              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width > 600
                      ? 110.w
                      : 200.w,
                  minWidth: 80,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.6),
                      blurRadius: 26,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.solid,
                    ),
                  ],
                  borderRadius: AppBorders.xxxxs,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  color: AppColors.mainBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    top: 8,
                    right: 16,
                    left: 16,
                  ),
                  child: LoginViewForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
