import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

class FloatingChatButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool hasUnreadMessages;
  final int unreadCount;
  final bool isExpanded;

  const FloatingChatButton({
    Key? key,
    this.onTap,
    this.hasUnreadMessages = false,
    this.unreadCount = 0,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation de pulsation pour les messages non lus
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animation de rebond au tap
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Animation d'échelle pour l'expansion
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Démarrer l'animation de pulsation si il y a des messages non lus
    if (widget.hasUnreadMessages) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FloatingChatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.hasUnreadMessages && !oldWidget.hasUnreadMessages) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.hasUnreadMessages && oldWidget.hasUnreadMessages) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _bounceAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: widget.isExpanded ? _buildExpandedButton() : _buildCompactButton(),
        );
      },
    );
  }

  Widget _buildCompactButton() {
    return GestureDetector(
      onTapDown: (_) {
        _bounceController.forward();
      },
      onTapUp: (_) {
        _bounceController.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _bounceController.reverse();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryLightColor,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: widget.hasUnreadMessages ? 2 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Icône principale
            Center(
              child: Transform.scale(
                scale: widget.hasUnreadMessages ? _pulseAnimation.value : 1.0,
                child: const Icon(
                  Icons.chat_bubble,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // Badge de notification
            if (widget.hasUnreadMessages)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    widget.unreadCount > 99 ? '99+' : '${widget.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Effet de ripple
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: widget.onTap,
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedButton() {
    return GestureDetector(
      onTapDown: (_) {
        _bounceController.forward();
      },
      onTapUp: (_) {
        _bounceController.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _bounceController.reverse();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryLightColor,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: widget.hasUnreadMessages ? _pulseAnimation.value : 1.0,
              child: const Icon(
                Icons.chat_bubble,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Assistant IA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.hasUnreadMessages) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.unreadCount > 99 ? '99+' : '${widget.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget de chat rapide avec suggestions
class QuickChatSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final VoidCallback? onOpenFullChat;

  const QuickChatSuggestions({
    Key? key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.onOpenFullChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.elevatedShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Assistant IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onOpenFullChat,
                icon: const Icon(
                  Icons.open_in_full,
                  color: AppTheme.textSecondary,
                ),
                tooltip: 'Ouvrir le chat complet',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Message d'accueil
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Bonjour ! Comment puis-je vous aider à trouver votre logement idéal ?',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Suggestions rapides
          const Text(
            'Suggestions rapides :',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),

          const SizedBox(height: 8),

          // Bouton pour ouvrir le chat complet
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenFullChat,
              icon: const Icon(Icons.chat, size: 18),
              label: const Text('Ouvrir le chat complet'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onSuggestionTap(suggestion),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: AppTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Suggestions par défaut pour le chat
class DefaultChatSuggestions {
  static const List<String> suggestions = [
    'Je cherche un appartement à Dakar',
    'Quels sont les prix moyens ?',
    'Comment contacter un propriétaire ?',
    'Aide pour les filtres de recherche',
    'Conseils pour visiter un logement',
  ];
}

