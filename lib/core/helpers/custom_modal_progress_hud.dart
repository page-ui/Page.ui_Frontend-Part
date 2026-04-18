import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pageui/core/helpers/custom_cli_loading_indicator.dart';

class CustomModalProgressHud extends StatelessWidget {
  const CustomModalProgressHud({
    super.key,
    required this.child,
    required this.isLoading,
  });
  final Widget child;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      blur: 3,
      inAsyncCall: isLoading,
      progressIndicator: CustomCliLoadingIndicator(),
      child: child,
    );
  }
}
