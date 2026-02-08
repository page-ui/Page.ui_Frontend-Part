import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_images.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.width = 100});
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Image(image: AssetImage(Assets.assetsImagesLogoWithoutBackground)),
    );
  }
}
