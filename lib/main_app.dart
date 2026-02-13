import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_images.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';
import 'package:pageui/features/intro_screens/presentation/views/splash_view.dart';

class PageDotUi extends StatelessWidget {
  const PageDotUi({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 790),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, state) {
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Assets.assetsImagesMainBackground),
            ),
          ),
          child: MaterialApp(
            initialRoute: SplashView.routeName,
            onGenerateRoute: onGenerateRoute,
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
        );
      },
    );
  }
}
