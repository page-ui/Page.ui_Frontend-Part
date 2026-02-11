import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/custom_widget/custom_button.dart';

class VerifyOTPWidget extends StatefulWidget {
  const VerifyOTPWidget({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

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
        const Text(
          "VERIFY OTP",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 22,
            letterSpacing: 1.5,
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "ENTER THE 5-DIGIT CODE SENT TO YOU",
          style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Flexible(
              // Makes the box responsive to available width
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ), // Reduced margin for tight screens
                constraints: const BoxConstraints(
                  maxWidth: 50,
                  minWidth: 40,
                ), // Keeps boxes from getting too huge or tiny
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: AppColors.primaryColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controllers[index],
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

        const SizedBox(height: 30),
        CustomButton(title: "VERIFY", onPressed: widget.onPressed),
      ],
    );
  }
}
