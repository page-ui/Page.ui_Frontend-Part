import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/core/constants/borders.dart';
import 'package:page_ui/core/enum/screen_type.dart';
import 'package:page_ui/core/helpers/custom_cli_loading_indicator.dart';
import 'package:page_ui/core/helpers/custom_show_snack_bar.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/features/chat/domain/entities/chat_entity.dart';
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
  bool _isHistoryOpen = false;
  bool _isChatOpen = true;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── URL sync ────────────────────────────────────────────────────────

  /// Updates the browser URL to `/app/chat/<name>` without rebuilding routes.
  void _updateUrlForChat(ChatEntity chat) {
    // final encoded = Uri.encodeComponent(chat.name);
    final targetPath = '/app/chat/${chat.name}';

    // Silently replace the URL in the browser bar without triggering navigation
    SystemNavigator.routeInformationUpdated(
      uri: Uri.parse(targetPath),
      replace: true,
    );
  }

  // ── Toggle helpers ──────────────────────────────────────────────────

  void _toggleHistory() => setState(() => _isHistoryOpen = !_isHistoryOpen);

  void _toggleChatPanel() {
    if (context.isMobile) {
      _animateToPage(0);
    } else {
      setState(() => _isChatOpen = !_isChatOpen);
    }
  }

  void _showUIFrame() {
    if (context.isMobile) _animateToPage(1);
  }

  void _animateToPage(int page) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  // ── Create-chat handler ─────────────────────────────────────────────

  Future<void> _onSendFromLanding(BuildContext context, String content) async {
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
      content: content,
      attachment: attachment,
    );

    if (!context.mounted) return;
    if (pickFileCubit.isImagePicked) pickFileCubit.removeImage();
  }



  // ── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PickFileCubit()),
        BlocProvider(create: (_) => getit.get<ChatMessagesCubit>()),
      ],
      child: BlocConsumer<ChatHomeCubit, ChatHomeState>(
        listenWhen: (prev, curr) {
          if (curr is ChatHomeError) return true;
          if (curr is ChatHomeActive) {
            return prev.selectedChat?.id != curr.chat.id;
          }
          return false;
        },
        listener: _onHomeStateChanged,
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  HomeAppbar(onHistoryPressed: _toggleHistory),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildContent(context, state),
                        if (state is ChatHomeLoading) _buildLoadingOverlay(),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isHistoryOpen)
                HistoryPanelOverlay(
                  width:MediaQuery.sizeOf(context).width < 300? MediaQuery.sizeOf(context).width:310,
                  panel: HistoryPanel(onPressed: _toggleHistory),
                  onClose: () => setState(() => _isHistoryOpen = false),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Listener ────────────────────────────────────────────────────────

  void _onHomeStateChanged(BuildContext context, ChatHomeState state) {
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
        _isChatOpen = true;
        _isHistoryOpen = false;
      });
      if (context.isMobile && _pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      // Silently update the browser URL without triggering a rebuild
      _updateUrlForChat(state.chat);
    }
  }

  // ── Content switcher ────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, ChatHomeState state) {
    final hasChat = state.selectedChat != null;

    if (!hasChat) {
      return CreateNewChatSection(
        onSend: ({required content, attachmentUrl}) =>
            _onSendFromLanding(context, content),
      );
    }

    return context.isMobile
        ? _buildMobileLayout()
        : _buildDesktopLayout(context);
  }

  // ── Mobile: swipeable PageView ──────────────────────────────────────

  Widget _buildMobileLayout() {
    return PointerInterceptor(
      intercepting: false,
      child: PageView(
        controller: _pageController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius:AppBorders.zero ,
              color: AppColors.anotherGray.withValues(alpha: 0.6),
              border: Border.all(color: AppColors.darkGrey, width: 0.5),
            ),
            child: ChatPanel(onPressed: _showUIFrame),
          ),
          UIFrame(
            wrapWithExpanded: false,
            onRightButtonPressed: _toggleChatPanel,
          ),
        ],
      ),
    );
  }

  // ── Desktop / Tablet: side-by-side panels ───────────────────────────

  Widget _buildDesktopLayout(BuildContext context) {
    final chatWidth = context.isTablet ? 380.0 : 480.0;

    return Row(
      children: [
        CustomAnimatedContainerForTheHomePanel(
          isOpen: _isChatOpen,
          width: chatWidth,
          onPressed: _toggleChatPanel,
          child: ChatPanel(onPressed: _toggleChatPanel),
        ),
        Expanded(
          child: UIFrame(
            wrapWithExpanded: false,
            onRightButtonPressed: _toggleChatPanel,
          ),
        ),
      ],
    );
  }

  // ── Loading overlay ─────────────────────────────────────────────────

  Widget _buildLoadingOverlay() {
    return const Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(dismissible: false, color: Colors.black38),
          Center(child: CustomCliLoadingIndicator()),
        ],
      ),
    );
  }
}
