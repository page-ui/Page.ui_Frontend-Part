import 'package:flutter/material.dart';

class IframeView extends StatelessWidget {
  const IframeView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'UI preview is only available on web.\n$url',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
