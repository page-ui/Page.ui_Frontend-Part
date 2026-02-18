import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/features/auth/domain/params/login_params.dart';
import 'package:pageui/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:pageui/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:pageui/features/auth/presentation/widgets/custom_row_auth.dart';
import 'package:pageui/features/auth/presentation/widgets/do_not_have_an_account_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/email_validator.dart';
import 'package:pageui/features/auth/presentation/widgets/forget_password_widget.dart';
import 'package:pageui/features/auth/presentation/widgets/password_text_form_field.dart';

class LoginViewForm extends StatefulWidget {
  LoginViewForm({super.key, required this.onChangeLoadingValue});
  final void Function(bool)? onChangeLoadingValue;
  @override
  State<LoginViewForm> createState() => _LoginViewFormState();
}

class _LoginViewFormState extends State<LoginViewForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          showWebSnackBar(context: context, message: "Login Success");
          widget.onChangeLoadingValue!(false);
          AppRoutes.pushHomeView(context);
        } else if (state is LoginFailure) {
          showWebSnackBar(context: context, message: state.message);
          widget.onChangeLoadingValue!(false);
        } else if (state is LoginLoading) {
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
            SizedBox(height: 6),
            DoNotHaveAnAccountWidget(),
            SizedBox(height: 8),
            ForgetPasswordWidget(),
            SizedBox(height: 20),
            Center(
              child: CustomButton(
                title: 'Login',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<LoginCubit>().login(
                      params: LoginParams(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                    FocusScope.of(context).unfocus();
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                AppRoutes.pushHomeView(context);
              },
              child: Text(
                "Go to Home View",
                style: TextStyle(color: AppColors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
