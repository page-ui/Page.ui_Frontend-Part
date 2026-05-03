import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/core/constants/borders.dart';
import 'package:page_ui/features/chat/presentation/widgets/home_panel_on_closed.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class CustomAnimatedContainerForTheHomePanel extends StatefulWidget {
  const CustomAnimatedContainerForTheHomePanel({
    super.key,
    required this.isOpen,
    required this.isLeft,
    this.onPressed,
    required this.width,
    required this.child,
  });

  final bool isOpen;
  final bool isLeft;
  final void Function()? onPressed;
  final double width;
  final Widget child;

  @override
  State<CustomAnimatedContainerForTheHomePanel> createState() =>
      _CustomAnimatedContainerForTheHomePanelState();
}

class _CustomAnimatedContainerForTheHomePanelState
    extends State<CustomAnimatedContainerForTheHomePanel> {
  late bool _isAnimating;

  @override
  void initState() {
    super.initState();
    _isAnimating = false;
  }

  @override
  void didUpdateWidget(
    covariant CustomAnimatedContainerForTheHomePanel oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      setState(() {
        _isAnimating = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      width: widget.isOpen ? widget.width : 40,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: widget.isLeft ? 0 : 10,
        left: widget.isLeft ? 10 : 0,
      ),
      padding: EdgeInsets.all(widget.isOpen ? 0 : 4),
      decoration: BoxDecoration(
        borderRadius: AppBorders.xxxxs,
        color: AppColors.anotherGray.withValues(alpha: 0.6),
        border: Border.all(color: AppColors.darkGrey, width: 0.5),
      ),
      onEnd: () => setState(() => _isAnimating = false),
      child: PointerInterceptor(
        child: (widget.isOpen && !_isAnimating)
            ? widget.child
            : HomePanelOnClosed(
                isLeftPanel: widget.isLeft,
                onPressed: widget.onPressed,
                isOpen: widget.isOpen,
              ),
      ),
    );
  }
}
