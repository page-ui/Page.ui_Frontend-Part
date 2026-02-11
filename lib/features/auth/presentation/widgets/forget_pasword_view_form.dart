import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/email_validator.dart';
import 'package:pageui/features/auth/presentation/widgets/have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/verify_o_t_p_widget.dart';

class ForgetPaswordViewForm extends StatefulWidget {
  const ForgetPaswordViewForm({super.key});

  @override
  State<ForgetPaswordViewForm> createState() => _ForgetPaswordViewFormState();
}

class _ForgetPaswordViewFormState extends State<ForgetPaswordViewForm> {
  GlobalKey<FormState> formKeyEmailCheck = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCodeVerify = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPasswordReset = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late List<TextEditingController> controllers;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(5, (_) => TextEditingController());
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_currentStep > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: previousStep,
            ),
          ),

        SizedBox(
          height: 270,
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [_emailStep(), _codeStep(), _resetPasswordStep()],
          ),
        ),
      ],
    );
  }

  Widget _emailStep() {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKeyEmailCheck,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "Type Your Email"),
          const SizedBox(height: 4),
          AuthTextFormField(
            controller: _emailController,
            validator: EmailValidator,
          ),
          const SizedBox(height: 4),
          HaveAnAccountWidget(),
          const SizedBox(height: 20),
          CustomButton(
            title: 'Send Code',
            onPressed: () {
              if (formKeyEmailCheck.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                showWebSnackBar(context: context, message: 'Check Your Email.');
                formKeyEmailCheck.currentState!.reset();
                nextStep();
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

  Widget _codeStep() {
    autovalidateMode = AutovalidateMode.disabled;
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

          VerifyOTPWidget(controllers: controllers),
          const SizedBox(height: 30),
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
                showWebSnackBar(context: context, message: 'OTP Verified.');
                formKeyCodeVerify.currentState!.reset();
                nextStep();
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

  Widget _resetPasswordStep() {
    return Form(
      key: formKeyPasswordReset,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "New Password"),
          const SizedBox(height: 4),
          PasswordTextFormField(controller: _passwordController),
          const SizedBox(height: 16),
          customRowAuth(hint: "Confirm Password"),
          const SizedBox(height: 4),
          PasswordTextFormField(controller: _confirmPasswordController),
          const SizedBox(height: 20),
          CustomButton(
            title: 'Reset Password',
            onPressed: () {
              if (formKeyPasswordReset.currentState!.validate()) {
                if (_confirmPasswordController.text ==
                    _passwordController.text) {
                  FocusScope.of(context).unfocus();
                  showWebSnackBar(
                    context: context,
                    message: 'Password Reset Successfully.',
                  );
                  formKeyPasswordReset.currentState!.reset();
                  AppRoutes.pop(context);
                } else {
                  showWebSnackBar(
                    context: context,
                    message: "Password and Confirm Password must be same",
                    backgroundColor: AppColors.red,
                    textColor: AppColors.white,
                  );
                }
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

  final PageController _controller = PageController();
  int _currentStep = 0;

  void nextStep() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    setState(() => _currentStep++);
  }

  void previousStep() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    setState(() => _currentStep--);
  }
}
