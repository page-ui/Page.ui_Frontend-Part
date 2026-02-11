import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_images.dart';

class MainBackground extends StatelessWidget {
  const MainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsImagesMainBackground,
      fit: BoxFit.fill,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
    );
  }
}
