import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// Widget de chargement principal
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 50,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// Widget de chargement en overlay
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}

// Shimmer effect pour le chargement des listes
class ShimmerWidget extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const ShimmerWidget({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                AppTheme.shimmerBase,
                AppTheme.shimmerHighlight,
                AppTheme.shimmerBase,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Skeleton pour les cartes d'annonces
class AnnonceCardSkeleton extends StatelessWidget {
  const AnnonceCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.shimmerBase,
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: AppTheme.shimmerBase,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Localisation
                  Container(
                    height: 16,
                    width: 200,
                    color: AppTheme.shimmerBase,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Caractéristiques
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 80,
                        color: AppTheme.shimmerBase,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 16,
                        width: 80,
                        color: AppTheme.shimmerBase,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Prix
                  Container(
                    height: 24,
                    width: 150,
                    color: AppTheme.shimmerBase,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Skeleton pour les listes
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget itemSkeleton;

  const ListSkeleton({
    Key? key,
    this.itemCount = 5,
    required this.itemSkeleton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => itemSkeleton,
    );
  }
}

// Widget d'état vide
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 80,
                color: AppTheme.textLight,
              ),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget d'erreur
class ErrorWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onRetry;

  const ErrorWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppTheme.errorColor,
            ),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (actionText != null && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Indicateur de chargement pour les boutons
class ButtonLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const ButtonLoadingIndicator({
    Key? key,
    this.color,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}

