import 'package:flutter/material.dart';
import 'package:pageui/features/chat/prsentation/widgets/chat_panel.dart';
import 'package:pageui/features/chat/prsentation/widgets/custom_panel_for_mobile_mode.dart';
import 'package:pageui/features/chat/prsentation/widgets/history_panel.dart';
import 'package:pageui/features/chat/prsentation/widgets/u_i_frame.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool isLeftOpen = true;
  bool isRightOpen = true;
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

        bool isMobile = constraints.maxWidth < 500;
        bool isTablet =
            constraints.maxWidth >= 500 && constraints.maxWidth < 1000;
        bool isDesktop = constraints.maxWidth >= 1000;

        return Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  if (!isMobile)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isLeftOpen ? leftWidth : 0,
                      child: ClipRect(child: HistoryPanel()),
                    ),

                  Expanded(
                    child: UIFrame(
                      isDesktop: isDesktop,
                      isMobile: isMobile,
                      isTablet: isTablet,
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
                    ),
                  ),

                  if (!isMobile)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isRightOpen ? rightWidth : 0,
                      child: ClipRect(child: ChatPanel()),
                    ),
                ],
              ),

              if (isMobile && isLeftOpen)
                CustomPanelForMobileMode(
                  width: leftWidth,
                  panel: HistoryPanel(),
                  onClose: () => setState(() => isLeftOpen = false),
                ),

              if (isMobile && isRightOpen)
                CustomPanelForMobileMode(
                  width: rightWidth,
                  panel: ChatPanel(),
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
