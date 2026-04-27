import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_images.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pageui/core/constants/constants.dart';

class NameAndTheLogo extends StatelessWidget {
  final VoidCallback? onTap;

  const NameAndTheLogo({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            child: Image.asset(
              Assets.assetsImagesLogoWithoutBackground,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            appName,
            style: AppTextStyles.headlineSmall!.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
