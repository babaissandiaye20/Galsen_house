import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/chat/controllers/chat_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/annonce.dart';
import 'custom_button.dart';
import 'annonce_card.dart';

class ChatWidget extends StatelessWidget {
  final ChatController controller = Get.find<ChatController>();

  ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) {
        return _buildChatButton();
      }
      return _buildChatInterface();
    });
  }

  Widget _buildChatButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: controller.showChat,
        backgroundColor: AppTheme.primaryColor,
        child: Stack(
          children: [
            const Icon(Icons.chat, color: Colors.white),
            if (controller.hasMessages && controller.isLastMessageFromBot)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        width: 350,
        height: 500,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.elevatedShadows,
        ),
        child: Column(
          children: [
            _buildChatHeader(),
            Expanded(child: _buildMessagesList()),
            _buildQuickReplies(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.support_agent, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant Immobilier',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'En ligne',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: controller.hideChat,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount:
            controller.messages.length + (controller.isTyping.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.messages.length &&
              controller.isTyping.value) {
            return _buildTypingIndicator();
          }

          final message = controller.messages[index];
          return _buildMessageBubble(message);
        },
      );
    });
  }

  Widget _buildMessageBubble(Message message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.support_agent, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        message.isUser
                            ? AppTheme.primaryColor
                            : AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomLeft:
                          message.isUser
                              ? const Radius.circular(20)
                              : const Radius.circular(4),
                      bottomRight:
                          message.isUser
                              ? const Radius.circular(4)
                              : const Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color:
                          message.isUser ? Colors.white : AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),

                if (message.suggestions != null &&
                    message.suggestions!.isNotEmpty)
                  _buildSuggestions(message.suggestions!),

                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),

          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.accentColor,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions(List<Annonce> suggestions) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final annonce = suggestions[index];
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 8),
            child: AnnonceCardCompact(
              annonce: annonce,
              onTap: () => controller.onAnnonceSelected(annonce),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(Icons.support_agent, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(
                20,
              ).copyWith(bottomLeft: const Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickReplies() {
    return Obx(() {
      if (controller.quickReplies.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.quickReplies.length,
          itemBuilder: (context, index) {
            final reply = controller.quickReplies[index];
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: OutlinedButton(
                onPressed: () => controller.sendQuickReply(reply),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(reply, style: const TextStyle(fontSize: 12)),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return TextField(
                onChanged:
                    (value) => controller.messageController.value = value,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.sendMessage(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Tapez votre message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: AppTheme.dividerColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Obx(() {
            return IconButton(
              onPressed:
                  controller.messageController.value.trim().isNotEmpty
                      ? () => controller.sendMessage(
                        controller.messageController.value,
                      )
                      : null,
              icon: const Icon(Icons.send),
              color: AppTheme.primaryColor,
            );
          }),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

// Widget pour intégrer le chat dans les pages
class ChatFloatingWidget extends StatelessWidget {
  final Widget child;

  const ChatFloatingWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, ChatWidget()]);
  }
}
