import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/enum/screen_type.dart';
import 'package:pageui/core/helpers/custom_cli_loading_indicator.dart';
import 'package:pageui/core/helpers/custom_show_snack_bar.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/features/chat/domain/usecases/upload_attachment_usecase.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_panel/chat_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_animated_container_for_the_home_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_panel_for_mobile_mode.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel/history_panel.dart';
import 'package:pageui/features/chat/presentation/widgets/landing_page.dart';
import 'package:pageui/features/chat/presentation/widgets/ui_frame/home_appbar.dart';
import 'package:pageui/features/chat/presentation/widgets/ui_frame/u_i_frame.dart';

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

  Future<void> _onLandingPageSend({
    required BuildContext context,
    required String content,
  }) async {
    final pickFileCubit = context.read<PickFileCubit>();
    final chatHomeCubit = context.read<ChatHomeCubit>();

    final attachment = pickFileCubit.isImagePicked
        ? UploadAttachmentInput(
            bytes: pickFileCubit.imageBytes!,
            fileName: pickFileCubit.imageFileName!,
            contentType: pickFileCubit.imageContentType!,
          )
        : null;

    await chatHomeCubit.createChat(
      name: _generateChatName(content),
      content: content,
      attachment: attachment,
    );

    if (!context.mounted) return;
    if (pickFileCubit.isImagePicked) {
      pickFileCubit.removeImage();
    }
  }

  String _generateChatName(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return 'Chat ${DateTime.now().millisecondsSinceEpoch}';
    }
    return trimmed.length > 40 ? '${trimmed.substring(0, 40)}…' : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PickFileCubit()),
        BlocProvider(create: (context) => getit.get<ChatMessagesCubit>()),
      ],
      child: BlocConsumer<ChatHomeCubit, ChatHomeState>(
        listenWhen: (previous, current) {
          if (current is ChatHomeError) {
            return true;
          }

          if (current is ChatHomeActive) {
            return previous.selectedChat?.id != current.chat.id;
          }

          return false;
        },
        listener: (context, state) {
          if (state is ChatHomeError) {
            showWebSnackBar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
            );
          }

          if (state is ChatHomeActive) {
            setState(() {
              isRightOpen = true;
              if (context.isMobile || context.isTablet) {
                isLeftOpen = false;
              }
            });
          }
        },
        builder: (context, homeState) {
          _handleOpenningDrawers();
          final isMobile = context.isMobile;
          final hasSelectedChat = homeState.selectedChat != null;

          return Scaffold(
            appBar: const HomeAppbar(),
            body: Stack(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Visibility(
                        visible: isMobile && !isLeftOpen && !hasSelectedChat,
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
                    if (!hasSelectedChat)
                      Expanded(
                        child: LandingPage(
                          onSend: ({required content, attachmentUrl}) {
                            _onLandingPageSend(
                              context: context,
                              content: content,
                            );
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (homeState is ChatHomeLoading)
                  const Positioned.fill(
                    child: Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: Colors.black38,
                        ),
                        Center(child: CustomCliLoadingIndicator()),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
