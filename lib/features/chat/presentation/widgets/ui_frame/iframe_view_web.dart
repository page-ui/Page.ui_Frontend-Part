import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

class IframeView extends StatelessWidget {
  const IframeView({super.key, required this.url});

  final String url;

  static final Set<String> _registeredViewTypes = <String>{};

  String get _viewType => 'pageui-iframe-${Uri.encodeComponent(url)}';

  void _ensureRegistered() {
    if (_registeredViewTypes.contains(_viewType)) return;
    _registeredViewTypes.add(_viewType);
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = url
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'clipboard-read; clipboard-write';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    _ensureRegistered();
    return HtmlElementView(viewType: _viewType);
  }
}
