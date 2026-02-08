import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customShowSnackBar({
  required final String message,
  required final BuildContext context,
  Duration duration = const Duration(seconds: 3),
  Color? backgroundColor,
  SnackBarAction? action,
  Widget? icon,
}) {
  final ThemeData theme = Theme.of(context);
  final Color bg = backgroundColor ?? theme.colorScheme.error;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 8)],
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
      action: action,
    ),
  );
}
