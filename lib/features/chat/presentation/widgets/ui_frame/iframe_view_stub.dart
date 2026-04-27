import 'dart:js_interop';
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
    viewID =
        'pageui-view-${widget.url.isEmpty ? 'empty' : widget.url.hashCode}';

    ui_web.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      final web.HTMLDivElement baseElement =
          web.document.createElement('div') as web.HTMLDivElement;

      baseElement.style
        ..width = '100%'
        ..height = '100%'
        ..overflow = 'hidden'
        ..display = 'flex'
        ..flexDirection = 'column'
        ..backgroundColor = 'transparent';

      if (widget.url.trim().isEmpty) {
        final web.HTMLDivElement emptyState =
            web.document.createElement('div') as web.HTMLDivElement;
        emptyState.style
          ..flex = '1'
          ..display = 'flex'
          ..flexDirection = 'column'
          ..alignItems = 'center'
          ..justifyContent = 'center'
          ..fontFamily = 'sans-serif';

        emptyState.innerHTML =
            '''
          <div style="text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center;">
            <div style="margin-bottom: 12px; opacity: 0.4;">
              <img src="assets/images/logoWithoutBackground.png" width="48" height="48" alt="Logo" />
            </div>
            <div style="color: white; opacity: 0.7; font-size: 16px; margin-bottom: 4px; font-weight: 500;">UI Preview</div>
            <div style="color: #E5E7EB; opacity: 0.4; font-size: 13px;">Generated UI will render here</div>
          </div>
        '''
                .toJS;
        baseElement.appendChild(emptyState);
      } else {
        final web.HTMLIFrameElement iframe =
            web.document.createElement('iframe') as web.HTMLIFrameElement;

        iframe.src = widget.url;

        iframe.style
          ..border = '0'
          ..width = '100%'
          ..height = '100%';

        iframe.loading = 'lazy';
        iframe.allowFullscreen = true;
        iframe.allow = 'clipboard-read; clipboard-write';

        baseElement.appendChild(iframe);
      }

      return baseElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: HtmlElementView(viewType: viewID));
  }
}
