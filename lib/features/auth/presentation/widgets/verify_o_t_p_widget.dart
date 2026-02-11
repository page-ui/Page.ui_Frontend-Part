import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class VerifyOTPWidget extends StatefulWidget {
  VerifyOTPWidget({super.key, required this.controllers});
  List<TextEditingController> controllers;
  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget> {
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(maxWidth: 50, minWidth: 40),
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border.all(color: AppColors.primaryColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  controller: widget.controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 22,
                  ),
                  cursorColor: AppColors.primaryColor,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => _onChanged(value, index),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
