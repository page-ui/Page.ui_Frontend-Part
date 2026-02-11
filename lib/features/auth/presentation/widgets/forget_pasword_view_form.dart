import 'package:flutter/material.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/verify_o_t_p_widget.dart';

class ForgetPaswordViewForm extends StatefulWidget {
  const ForgetPaswordViewForm({super.key});

  @override
  State<ForgetPaswordViewForm> createState() => _ForgetPaswordViewFormState();
}

class _ForgetPaswordViewFormState extends State<ForgetPaswordViewForm> {
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
          height: 230,
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
    String email;
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customRowAuth(hint: "Type Your Email"),
          const SizedBox(height: 4),
          AuthTextFormField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 4),
          HaveAnAccountWidget(),
          const SizedBox(height: 20),
          CustomButton(title: 'Send Code', onPressed: nextStep),
        ],
      ),
    );
  }

  Widget _codeStep() {
    // TODO: Implement code verification logic
    return Column(children: [VerifyOTPWidget(onPressed: nextStep)]);
  }

  Widget _resetPasswordStep() {
    String newPassword;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customRowAuth(hint: "New Password"),
        const SizedBox(height: 4),
        PasswordTextFormField(
          onChanged: (String value) {
            setState(() {
              newPassword = value;
            });
          },
        ),
        const SizedBox(height: 20),
        CustomButton(title: 'Reset Password', onPressed: () {}),
      ],
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
