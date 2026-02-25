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
  String _lastMode = "";

  final double leftWidth = 260;
  final double rightWidth = 290;

  void _handleOpenningDrawers() {
    String currentMode;
    if (context.isMobile)
      currentMode = "mobile";
    else if (context.isTablet)
      currentMode = "tablet";
    else
      currentMode = "desktop";

    if (_lastMode != currentMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (currentMode == "tablet") {
            isLeftOpen = false;
          } else if (currentMode == "mobile") {
            isLeftOpen = false;
            isRightOpen = false;
          }
          _lastMode = currentMode;
        });
      });
    }
  }

  onPressedLeftButton({required bool isMobile, required bool isTablet}) {
    setState(() {
      isLeftOpen = !isLeftOpen;
      if ((isTablet || isMobile) && isLeftOpen) {
        isRightOpen = false;
      }
    });
  }

  onPressedRightButton({required bool isMobile, required bool isTablet}) {
    setState(() {
      isRightOpen = !isRightOpen;
      if ((isTablet || isMobile) && isRightOpen) {
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
        bool isTablet = context.isTablet;

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
                        onPressedLeftButton(
                          isMobile: isMobile,
                          isTablet: isTablet,
                        );
                      },
                      child: HistoryPanel(
                        onPressed: () {
                          onPressedLeftButton(
                            isMobile: isMobile,
                            isTablet: isTablet,
                          );
                        },
                      ),
                    ),

                  UIFrame(
                    onLeftButtonPressed: () {
                      onPressedLeftButton(
                        isMobile: isMobile,
                        isTablet: isTablet,
                      );
                    },
                    onRightButtonPressed: () {
                      onPressedRightButton(
                        isMobile: isMobile,
                        isTablet: isTablet,
                      );
                    },
                    isMobile: isMobile,
                  ),
                  if (!isMobile)
                    CustomAnimatedContainerForTheHomePanel(
                      child: ChatPanel(
                        onPressed: () {
                          onPressedRightButton(
                            isMobile: isMobile,
                            isTablet: isTablet,
                          );
                        },
                      ),
                      isLeft: false,
                      width: rightWidth,
                      isOpen: isRightOpen,
                      onPressed: () {
                        onPressedRightButton(
                          isMobile: isMobile,
                          isTablet: isTablet,
                        );
                      },
                    ),
                ],
              ),

              if (isMobile && isLeftOpen)
                CustomPanelForMobileMode(
                  width: leftWidth,
                  panel: HistoryPanel(
                    onPressed: () {
                      onPressedLeftButton(
                        isMobile: isMobile,
                        isTablet: isTablet,
                      );
                    },
                  ),
                  onClose: () => setState(() => isLeftOpen = false),
                ),

              if (isMobile && isRightOpen)
                CustomPanelForMobileMode(
                  width: rightWidth,
                  panel: ChatPanel(
                    onPressed: () {
                      onPressedRightButton(
                        isMobile: isMobile,
                        isTablet: isTablet,
                      );
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
