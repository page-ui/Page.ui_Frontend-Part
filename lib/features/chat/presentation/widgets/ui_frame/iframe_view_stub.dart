import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class IframeView extends StatefulWidget {
  final String url;

  const IframeView({super.key, required this.url});

  @override
  State<IframeView> createState() => _IframeViewState();
}

class _IframeViewState extends State<IframeView> {
  late final String viewID;

  @override
  void initState() {
    super.initState();

    viewID = 'story-taller-view-${widget.url.hashCode}';

    ui_web.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      final web.HTMLDivElement baseElement =
          web.document.createElement('div') as web.HTMLDivElement;

      baseElement.style
        ..width = '100%'
        ..height = '100%'
        ..overflow = 'hidden';

      final web.HTMLIFrameElement iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement;

      iframe.src = widget.url;

      iframe.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%';

      iframe.loading = 'lazy';
      iframe.allowFullscreen = true;

      baseElement.appendChild(iframe);
      return baseElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: HtmlElementView(viewType: viewID));
  }
}
