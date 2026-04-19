import 'package:flutter/material.dart';

import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/core/constants/borders.dart';
import 'package:pageui/features/chat/domain/constants/message_types.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';

class ChatMessageContent extends StatelessWidget {
  const ChatMessageContent({super.key, required this.message});

  final MessageEntity message;

  bool get _isAiRun => isAiMessageType(message.type);

  bool get _hasImage =>
      !_isAiRun &&
      message.attachmentUrl != null &&
      message.attachmentUrl!.trim().isNotEmpty;

  String? get _displayText {
    final content = message.content.trim();
    if (_isAiRun) {
      if (content.isEmpty) return aiMessageType;
      if (content.startsWith('/')) return 'http://localhost$content';
      return content;
    }

    if (content.isEmpty) return null;
    if (_hasImage && content.toLowerCase() == 'image') return null;
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isAiRun)
          _ChatMessageImage(
            imageUrl: message.attachmentUrl,
            heroTag: 'chat-image-${message.id}',
          ),
        if (_hasImage && _displayText != null) const SizedBox(height: 8),
        _ChatMessageText(content: _displayText),
      ],
    );
  }
}

class _ChatMessageImage extends StatelessWidget {
  const _ChatMessageImage({required this.imageUrl, required this.heroTag});

  final String? imageUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                _FullScreenImageViewer(imageUrl: url, heroTag: heroTag),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      },
      child: ClipRRect(
        borderRadius: AppBorders.xxxxs,
        child: Hero(
          tag: heroTag,
          child: Image.network(
            url,
            width: 260,
            height: 220,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 260,
                height: 220,
                color: AppColors.black.withValues(alpha: 0.2),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 260,
                height: 220,
                padding: const EdgeInsets.all(12),
                color: AppColors.black.withValues(alpha: 0.2),
                alignment: Alignment.center,
                child: Text(
                  'Failed to load image',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChatMessageText extends StatelessWidget {
  const _ChatMessageText({required this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    final text = content?.trim();
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      text,
      style: TextStyle(
        color: AppColors.white.withValues(alpha: 0.9),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  const _FullScreenImageViewer({required this.imageUrl, required this.heroTag});

  final String imageUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white.withValues(alpha: 0.8),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                color: AppColors.white,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.black.withValues(alpha: 0.45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
