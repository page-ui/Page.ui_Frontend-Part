import 'package:flutter/material.dart';
import 'package:pageui/features/chat/prsentation/widgets/chat_panel.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_animated_container_for_the_home_panel.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_panel_for_mobile_mode.dart';
import 'package:pageui/features/chat/prsentation/widgets/history_panel.dart';
import 'package:pageui/features/chat/prsentation/widgets/home_appbar.dart';
import 'package:pageui/features/chat/prsentation/widgets/u_i_frame.dart';

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

  void _handleOpenningDrawers(double width) {
    String currentMode;
    if (width < 500)
      currentMode = "mobile";
    else if (width < 1000)
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _handleOpenningDrawers(constraints.maxWidth);

        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1000;

        return Scaffold(
          appBar: HomeAppbar(),
          body: Stack(
            children: [
              Row(
                children: [
                  if (!isMobile)
                    CustomAnimatedContainerForTheHomePanel(
                      isLeft: true,
                      isOpen: isLeftOpen,
                      width: leftWidth,
                      onPressed: () {
                        setState(() {
                          isLeftOpen = !isLeftOpen;
                          if ((isTablet || isMobile) && isLeftOpen) {
                            isRightOpen = false;
                          }
                        });
                      },
                      child: HistoryPanel(
                        onPressed: () {
                          setState(() {
                            isLeftOpen = !isLeftOpen;
                            if ((isTablet || isMobile) && isLeftOpen) {
                              isRightOpen = false;
                            }
                          });
                        },
                      ),
                    ),

                  UIFrame(
                    onLeftButtonPressed: () {
                      setState(() {
                        isLeftOpen = !isLeftOpen;
                        if ((isTablet || isMobile) && isLeftOpen) {
                          isRightOpen = false;
                        }
                      });
                    },
                    onRightButtonPressed: () {
                      setState(() {
                        isRightOpen = !isRightOpen;
                        if ((isTablet || isMobile) && isRightOpen) {
                          isLeftOpen = false;
                        }
                      });
                    },
                    isMobile: isMobile,
                  ),
                  if (!isMobile)
                    CustomAnimatedContainerForTheHomePanel(
                      child: ChatPanel(
                        onPressed: () {
                          setState(() {
                            isRightOpen = !isRightOpen;
                            if ((isTablet || isMobile) && isRightOpen) {
                              isLeftOpen = false;
                            }
                          });
                        },
                      ),
                      isLeft: false,
                      width: rightWidth,
                      isOpen: isRightOpen,
                      onPressed: () {
                        setState(() {
                          isRightOpen = !isRightOpen;
                          if ((isTablet || isMobile) && isRightOpen) {
                            isLeftOpen = false;
                          }
                        });
                      },
                    ),
                ],
              ),

              if (isMobile && isLeftOpen)
                CustomPanelForMobileMode(
                  width: leftWidth,
                  panel: HistoryPanel(
                    onPressed: () {
                      setState(() {
                        isLeftOpen = !isLeftOpen;
                        if ((isTablet || isMobile) && isLeftOpen) {
                          isRightOpen = false;
                        }
                      });
                    },
                  ),
                  onClose: () => setState(() => isLeftOpen = false),
                ),

              if (isMobile && isRightOpen)
                CustomPanelForMobileMode(
                  width: rightWidth,
                  panel: ChatPanel(
                    onPressed: () {
                      setState(() {
                        isRightOpen = !isRightOpen;
                        if ((isTablet || isMobile) && isRightOpen) {
                          isLeftOpen = false;
                        }
                      });
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
