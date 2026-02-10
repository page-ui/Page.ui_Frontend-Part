import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:pageui/config/themes/app_images.dart';
import 'package:pageui/features/auth/presentation/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String routeName = "LoginView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AvifImage.asset(
            Assets.assetsImagesMainBackground2,
            fit: BoxFit.fill,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          ),
          LoginViewBody(),
        ],
      ),
    );
  }
}
