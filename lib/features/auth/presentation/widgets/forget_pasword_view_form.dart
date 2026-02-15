import 'package:flutter/material.dart';
import 'package:pageui/features/auth/presentation/widgets/password_reset.dart';
import 'package:pageui/features/auth/presentation/widgets/OTP_code_verfication.dart';
import 'package:pageui/features/auth/presentation/widgets/sent_code.dart';

class ForgetPaswordViewForm extends StatefulWidget {
  const ForgetPaswordViewForm({super.key});

  @override
  State<ForgetPaswordViewForm> createState() => _ForgetPaswordViewFormState();
}

class _ForgetPaswordViewFormState extends State<ForgetPaswordViewForm> {
  late List<TextEditingController> controllers;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email;
  @override
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
            children: [
              SentCode(
                nextStep: nextStep,
                onEmailChanged: (String e) {
                  setState(() {
                    email = e;
                  });
                },
              ),
              OTPCodeVerfication(
                controllers: controllers,
                nextStep: nextStep,
                email: email ?? "",
              ),
              PasswordReset(),
            ],
          ),
        ),
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
