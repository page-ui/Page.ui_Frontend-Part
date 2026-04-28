import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/core/custom_widget/animated_starfield_background.dart';
import 'package:pageui/features/intro_screens/presentation/views/landing_view.dart';

class PageDotUi extends StatelessWidget {
  const PageDotUi({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedStarfieldBackground(
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          initialRoute: LandingView.routeName,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          title: 'Page.ui',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.transparent,
            fontFamily: fontName,
          ),
          builder: (context, child) {
            AppTextStyles.init(context);
            return child ?? const SizedBox();
          },
        ),
      ),
    );
  }
}
