import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_images.dart';

class MainBackground extends StatelessWidget {
  const MainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(Assets.assetsImagesMainBackground, fit: BoxFit.cover),
    );
  }
}
