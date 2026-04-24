import 'package:web/web.dart' as web;

void openUiUrlInBrowser(String url) {
  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty) return;

  web.window.open(trimmedUrl, '_blank', 'noopener,noreferrer');
}
