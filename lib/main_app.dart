import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/features/auth/presentation/views/login_view.dart';

class PageDotUi extends StatelessWidget {
  const PageDotUi({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 790),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, state) {
        return MaterialApp(
          initialRoute: LoginView.routeName,
          onGenerateRoute: onGenerateRoute,
          title: 'Page.ui',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: AppColors.spaceBlack),
          builder: (context, child) {
            AppTextStyles.init(context);
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
