import 'package:flutter/material.dart';
import 'package:pageui/core/enum/screen_type.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_animated_container_for_the_home_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_panel_for_mobile_mode.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/home_appbar.dart';
import 'package:pageui/features/chat/presentation/widgets/u_i_frame.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool isLeftOpen = false;
  bool isRightOpen = false;
  ScreenType? _lastMode;

  final double leftWidth = 260;
  final double rightWidth = 290;

  void _handleOpenningDrawers() {
    ScreenType currentMode;
    if (context.isMobile)
      currentMode = ScreenType.mobile;
    else if (context.isTablet)
      currentMode = ScreenType.tablet;
    else
      currentMode = ScreenType.desktop;

    if (_lastMode != currentMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (currentMode == ScreenType.tablet) {
            isLeftOpen = false;
          } else if (currentMode == ScreenType.mobile) {
            isLeftOpen = false;
            isRightOpen = false;
          }
          _lastMode = currentMode;
        });
      });
    }
  }

  onPressedLeftButton({required BuildContext context}) {
    setState(() {
      isLeftOpen = !isLeftOpen;
      if ((context.isTablet || context.isMobile) && isLeftOpen) {
        isRightOpen = false;
      }
    });
  }

  onPressedRightButton({required BuildContext context}) {
    setState(() {
      isRightOpen = !isRightOpen;
      if ((context.isTablet || context.isMobile) && isRightOpen) {
        isLeftOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        _handleOpenningDrawers();

        bool isMobile = context.isMobile;

        return Scaffold(
          appBar: HomeAppbar(),
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isMobile)
                    CustomAnimatedContainerForTheHomePanel(
                      isLeft: true,
                      isOpen: isLeftOpen,
                      width: leftWidth,
                      onPressed: () {
                        onPressedLeftButton(context: context);
                      },
                      child: HistoryPanel(
                        onPressed: () {
                          onPressedLeftButton(context: context);
                        },
                      ),
                    ),

                  UIFrame(
                    onLeftButtonPressed: () {
                      onPressedLeftButton(context: context);
                    },
                    onRightButtonPressed: () {
                      onPressedRightButton(context: context);
                    },
                  ),
                  if (!isMobile)
                    CustomAnimatedContainerForTheHomePanel(
                      child: ChatPanel(
                        onPressed: () {
                          onPressedRightButton(context: context);
                        },
                      ),
                      isLeft: false,
                      width: rightWidth,
                      isOpen: isRightOpen,
                      onPressed: () {
                        onPressedRightButton(context: context);
                      },
                    ),
                ],
              ),

              if (isMobile && isLeftOpen)
                CustomPanelForMobileMode(
                  width: leftWidth,
                  panel: HistoryPanel(
                    onPressed: () {
                      onPressedLeftButton(context: context);
                    },
                  ),
                  onClose: () => setState(() => isLeftOpen = false),
                ),

              if (isMobile && isRightOpen)
                CustomPanelForMobileMode(
                  width: rightWidth,
                  panel: ChatPanel(
                    onPressed: () {
                      onPressedRightButton(context: context);
                    },
                  ),
                  onClose: () => setState(() => isRightOpen = false),
                  isRight: true,
                ),
            ],
          ),
        );
      },
    );
  }
}
