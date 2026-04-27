import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  late YoutubePlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'cOZ4Mc8b0dA',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
      ),
    );

    _controller.listen((state) {
      if (state.playerState == PlayerState.unStarted ||
          state.playerState == PlayerState.cued) {
        if (mounted && !_isInitialized) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 700;
        final medium = w >= 700 && w < 1100;

        final labelFont = compact
            ? 58.sp
            : medium
            ? 36.sp
            : 20.sp;
        final headFont = compact
            ? 120.sp
            : medium
            ? 80.sp
            : 36.sp;
        final bodyFont = compact
            ? 72.sp
            : medium
            ? 44.sp
            : 24.sp;
        final hPad = compact
            ? 80.w
            : medium
            ? 120.w
            : 200.w;

        final textContent = Column(
          crossAxisAlignment: compact
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              "About the Project",
              style: AppTextStyles.labelLarge?.copyWith(
                color: AppColors.primaryColor,
                letterSpacing: 2,
                fontSize: labelFont,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Bridging the gap between code and design.",
              textAlign: compact ? TextAlign.center : TextAlign.left,
              style: AppTextStyles.displaySmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: headFont,
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              "From an academic perspective, this platform explores prompt-driven design generation, pattern learning from large-scale visual data, and reducing design bias in generative systems.\n\nFrom a practical perspective, it aims to radically improve productivity for frontend developers and lower the barrier to entry for building visually stunning applications.",
              textAlign: compact ? TextAlign.center : TextAlign.left,
              style: AppTextStyles.titleLarge?.copyWith(
                color: AppColors.white.withValues(alpha: 0.6),
                height: 1.6,
                fontSize: bodyFont,
              ),
            ),
          ],
        );

        final visual = ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 400.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
            ),
            child: Stack(
              children: [
                PointerInterceptor(
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
                if (!_isInitialized)
                  Container(
                    color: AppColors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.lightCyan,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 150.h),
          child: compact
              ? Column(
                  children: [
                    visual,
                    SizedBox(height: 60.h),
                    textContent,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: textContent),
                    SizedBox(width: 100.w),
                    Expanded(child: visual),
                  ],
                ),
        );
      },
    );
  }
}
