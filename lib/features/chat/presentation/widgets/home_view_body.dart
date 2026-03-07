import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/enum/screen_type.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_animated_container_for_the_home_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_panel_for_mobile_mode.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/home_appbar.dart';
import 'package:pageui/features/chat/presentation/widgets/landing_page.dart';
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

  void _onCreateChat() {
    context.read<ChatHomeCubit>().createChat(name: 'New Chat');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatHomeCubit, ChatHomeState>(
      listener: (context, state) {
        if (state is ChatHomeActive) {
          context.read<SendMessageCubit>().loadMessages(chatId: state.chat.id);
        }
      },
      child: Builder(
        builder: (_) {
          _handleOpenningDrawers();
          bool isMobile = context.isMobile;

          return Scaffold(
            appBar: const HomeAppbar(),
            body: BlocBuilder<ChatHomeCubit, ChatHomeState>(
              builder: (context, homeState) {
                return Stack(
                  children: [
                    if (isMobile && isLeftOpen && (homeState is ChatHomeActive))
                      CustomPanelForMobileMode(
                        width: leftWidth,
                        panel: HistoryPanel(
                          onPressed: () {
                            onPressedLeftButton(context: context);
                          },
                        ),
                        onClose: () => setState(() => isLeftOpen = false),
                      ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Visibility(
                            visible:
                                isMobile &&
                                    !isLeftOpen &&
                                    !(homeState is ChatHomeActive)
                                ? true
                                : false,
                            child: CustomButtonIconForPanels(
                              isLeftPanel: true,
                              onPressed: () =>
                                  onPressedLeftButton(context: context),
                            ),
                          ),
                        ),
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
                        switch (homeState) {
                          ChatHomeInitial() => Expanded(
                            child: LandingPage(onCreateChat: _onCreateChat),
                          ),
                          ChatHomeLoading() => Expanded(
                            child: Stack(
                              children: [
                                LandingPage(onCreateChat: () {}),
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ChatHomeError(message: final msg) => Expanded(
                            child: LandingPage(
                              onCreateChat: _onCreateChat,
                              errorMessage: msg,
                            ),
                          ),
                          ChatHomeActive() => Expanded(
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                            onPressedRightButton(
                                              context: context,
                                            );
                                          },
                                        ),
                                        isLeft: false,
                                        width: rightWidth,
                                        isOpen: isRightOpen,
                                        onPressed: () {
                                          onPressedRightButton(
                                            context: context,
                                          );
                                        },
                                      ),
                                  ],
                                ),

                                if (isMobile && isRightOpen)
                                  CustomPanelForMobileMode(
                                    width: rightWidth,
                                    panel: ChatPanel(
                                      onPressed: () {
                                        onPressedRightButton(context: context);
                                      },
                                    ),
                                    onClose: () =>
                                        setState(() => isRightOpen = false),
                                    isRight: true,
                                  ),
                              ],
                            ),
                          ),
                        },
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
