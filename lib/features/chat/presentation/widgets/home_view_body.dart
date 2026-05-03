import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/core/constants/borders.dart';
import 'package:page_ui/core/enum/screen_type.dart';
import 'package:page_ui/core/helpers/custom_cli_loading_indicator.dart';
import 'package:page_ui/core/helpers/custom_show_snack_bar.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/features/chat/domain/usecases/upload_attachment_usecase.dart';
import 'package:page_ui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:page_ui/features/chat/presentation/controllers/chat_home_cubit/chat_home_state.dart';
import 'package:page_ui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:page_ui/features/chat/presentation/controllers/pick_file_cubit/pick_file_cubit.dart';
import 'package:page_ui/features/chat/presentation/widgets/chat_panel/chat_panel.dart';
import 'package:page_ui/features/chat/presentation/widgets/create_new_chat_section.dart';
import 'package:page_ui/features/chat/presentation/widgets/custom_animated_container_for_the_home_panel.dart';
import 'package:page_ui/features/chat/presentation/widgets/history_panel/history_panel.dart';
import 'package:page_ui/features/chat/presentation/widgets/history_panel/history_panel_overlay.dart';
import 'package:page_ui/features/chat/presentation/widgets/home_appbar.dart';
import 'package:page_ui/features/chat/presentation/widgets/ui_frame/u_i_frame.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool isHistoryOpen = false;
  bool isChatOpen = true;
  final PageController _mobilePageController = PageController();

  void onHistoryPressed() {
    setState(() {
      isHistoryOpen = !isHistoryOpen;
    });
  }

  void onPressedLeftButton({required BuildContext context}) {
    if (context.isMobile) {
      if (_mobilePageController.hasClients) {
        _mobilePageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
      return;
    }
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  void onPressedRightButton({required BuildContext context}) {
    if (context.isMobile) {
      if (_mobilePageController.hasClients) {
        _mobilePageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
      return;
    }
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

    final normalizedName = trimmed
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return normalizedName.length > 40
        ? '${normalizedName.substring(0, 40)}…'
        : normalizedName;
  }

  @override
  void dispose() {
    _mobilePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final chatWidth = context.isMobile
        ? MediaQuery.sizeOf(context).width - 35
        : context.isTablet
            ? 390.0
            : 480.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PickFileCubit()),
        BlocProvider(create: (context) => getit.get<ChatMessagesCubit>()),
      ],
      child: BlocConsumer<ChatHomeCubit, ChatHomeState>(
        listenWhen: (previous, current) {
          if (current is ChatHomeError) return true;
          if (current is ChatHomeActive) {
            return previous.selectedChat?.id != current.chat.id;
          }
          return false;
        },
        listener: (context, state) {
          if (state is ChatHomeError) {
            showSnackBar(
              context: context,
              message: state.message,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
            );
          }

          if (state is ChatHomeActive) {
            setState(() {
              isChatOpen = true;
              isHistoryOpen = false;
            });
            if (isMobile && _mobilePageController.hasClients) {
              _mobilePageController.jumpToPage(0);
            }
          }
        },
        builder: (context, homeState) {
          final hasSelectedChat = homeState.selectedChat != null;

          return Stack(
            children: [
              Column(
                children: [
                  HomeAppbar(onHistoryPressed: onHistoryPressed),
                  Expanded(
                    child: Stack(
                      children: [
                        if (!hasSelectedChat)
                          CreateNewChatSection(
                            onSend: ({required content, attachmentUrl}) {
                              _onLandingPageSend(
                                context: context,
                                content: content,
                              );
                            },
                          )
                        else if (isMobile)
                          PointerInterceptor(
                            intercepting: false,
                            child: PageView(
                              controller: _mobilePageController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: AppBorders.xxxxs,
                                    color: AppColors.anotherGray
                                        .withValues(alpha: 0.6),
                                    border: Border.all(
                                        color: AppColors.darkGrey, width: 0.5),
                                  ),
                                  child: ChatPanel(
                                    onPressed: () =>
                                        onPressedRightButton(context: context),
                                  ),
                                ),
                                UIFrame(
                                  wrapWithExpanded: false,
                                  onRightButtonPressed: () =>
                                      onPressedLeftButton(context: context),
                                ),
                              ],
                            ),
                          )
                        else
                          Row(
                            children: [
                              CustomAnimatedContainerForTheHomePanel(
                                isOpen: isChatOpen,
                                isLeft: true,
                                width: chatWidth.toDouble(),
                                onPressed: () =>
                                    onPressedLeftButton(context: context),
                                child: ChatPanel(
                                  onPressed: () =>
                                      onPressedLeftButton(context: context),
                                ),
                              ),
                              Expanded(
                                child: UIFrame(
                                  wrapWithExpanded: false,
                                  onRightButtonPressed: () =>
                                      onPressedLeftButton(context: context),
                                ),
                              ),
                            ],
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
                  ),
                ],
              ),
              if (isHistoryOpen)
                HistoryPanelOverlay(
                  width: 300,
                  panel: HistoryPanel(onPressed: onHistoryPressed),
                  onClose: () => setState(() => isHistoryOpen = false),
                ),
            ],
          );
        },
      ),
    );
  }
}
