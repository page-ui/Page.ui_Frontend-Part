import 'package:flutter/material.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/about_section.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/features_section.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/footer_section.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/hero_section.dart';
import 'package:pageui/features/intro_screens/presentation/widgets/landing_nav_bar.dart';

class LandingView extends StatefulWidget {
  static const String routeName = "LandingView";

  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                HeroSection(),
                FeaturesSection(),
                AboutSection(),
                FooterSection(),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNavBar(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }
}
