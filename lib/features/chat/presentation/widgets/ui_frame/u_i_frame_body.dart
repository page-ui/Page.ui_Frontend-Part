import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';
import 'package:pageui/features/chat/presentation/widgets/custom_button_icon_for_panels.dart';
import 'package:pageui/features/chat/presentation/widgets/ui_frame/iframe_view.dart';

class UIFrameBody extends StatelessWidget {
  const UIFrameBody({
    super.key,
    required this.isMobile,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  final bool isMobile;
  final void Function()? onLeftButtonPressed;
  final void Function()? onRightButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AbsorbPointer(
          absorbing: isMobile ? false : true,
          child: Opacity(
            opacity: isMobile ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonIconForPanels(
                  isLeftPanel: true,
                  onPressed: onLeftButtonPressed,
                ),
                CustomButtonIconForPanels(
                  isLeftPanel: false,
                  onPressed: onRightButtonPressed,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocSelector<ChatMessagesCubit, ChatMessagesState, String>(
            selector: (state) => state.activeAiRunUrl ?? '',
            builder: (context, url) {
              return IframeView(key: ValueKey(url), url: url);
            },
          ),
        ),
      ],
    );
  }
}
