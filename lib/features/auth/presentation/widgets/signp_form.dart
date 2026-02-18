import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/domain/params/signup_params.dart';
import 'package:pageui/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/email_validator.dart';
import 'package:pageui/features/auth/presentation/widgets/have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class SignpForm extends StatefulWidget {
  const SignpForm({super.key, required this.onChangeLoadingValue});
  final void Function(bool)? onChangeLoadingValue;

  @override
  State<SignpForm> createState() => _SignpFormState();
}

class _SignpFormState extends State<SignpForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _confirmpasswordController;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmpasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          showWebSnackBar(context: context, message: "Login Success");
          widget.onChangeLoadingValue!(false);
          AppRoutes.pushHomeView(context);
        } else if (state is SignupFailure) {
          showWebSnackBar(context: context, message: state.message);
          widget.onChangeLoadingValue!(false);
        } else if (state is SignupLoading) {
          widget.onChangeLoadingValue!(true);
        } else {
          widget.onChangeLoadingValue!(false);
        }
      },
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customRowAuth(hint: "Name"),
            SizedBox(height: 4),
            AuthTextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.length < 4) {
                  return 'Username must be at least 3 characters';
                }
                if (value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            customRowAuth(hint: "Email"),
            SizedBox(height: 4),
            AuthTextFormField(
              controller: _emailController,
              validator: EmailValidator,
            ),

            SizedBox(height: 16),

            customRowAuth(hint: "Password"),
            SizedBox(height: 4),
            PasswordTextFormField(controller: _passwordController),

            SizedBox(height: 16),

            customRowAuth(hint: "Confirm Password"),
            SizedBox(height: 4),
            PasswordTextFormField(controller: _confirmpasswordController),

            SizedBox(height: 6),

            HaveAnAccountWidget(),

            SizedBox(height: 20),

            Center(
              child: CustomButton(
                title: "Register",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (_confirmpasswordController.text ==
                        _passwordController.text) {
                      context.read<SignupCubit>().signup(
                        params: SignupParams(
                          email: _emailController.text,
                          password: _passwordController.text,
                          userName: _nameController.text,
                        ),
                      );
                      FocusScope.of(context).unfocus();
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
            ),
          ],
        ),
      ),
    );
  }
}
