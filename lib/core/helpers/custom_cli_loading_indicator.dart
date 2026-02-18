import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';

class CustomCliLoadingIndicator extends StatefulWidget {
  const CustomCliLoadingIndicator({super.key, this.accentColor = AppColors.red});

  final Color accentColor;

  @override
  State<CustomCliLoadingIndicator> createState() => _CustomCliLoadingIndicatorState();
}

class _CustomCliLoadingIndicatorState extends State<CustomCliLoadingIndicator> {
  late Timer _timer;
  int _dotCount = 0;
  int _progress = 0;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
        _progress = (_progress + 4) % 104;
        _showCursor = !_showCursor;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get dots => '.' * _dotCount;

  String get progressBar {
    int totalBlocks = 20;
    int filled = (_progress / 100 * totalBlocks).floor();
    return '█' * filled + '░' * (totalBlocks - filled);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(170),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 14,
          height: 1.6,
          color: widget.accentColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('> generating preview'),
            Text('> compiling layout$dots'),
            const SizedBox(height: 12),
            Text(
              '> rendering components $progressBar ${_progress.clamp(0, 100)}%',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('>'),
                const SizedBox(width: 4),
                Text(
                  _showCursor ? '|' : ' ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
