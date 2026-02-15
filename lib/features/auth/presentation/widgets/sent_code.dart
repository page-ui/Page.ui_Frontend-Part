import 'package:flutter/material.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/email_validator.dart';
import 'package:pageui/features/auth/presentation/widgets/have_an_account_widget.dart';

class SentCode extends StatefulWidget {
  const SentCode({
    super.key,
    required this.nextStep,
    required this.onEmailChanged,
  });
  final void Function() nextStep;
  final ValueChanged<String> onEmailChanged;
  @override
  State<SentCode> createState() => _SentCodeState();
}

class _SentCodeState extends State<SentCode> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKeyEmailCheck = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                widget.onEmailChanged(_emailController.text);
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
