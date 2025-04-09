import 'package:flutter/material.dart';


class NeuBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const NeuBox({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.grey.shade400
                : Colors.black.withOpacity(0.5),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade800.withOpacity(0.5),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}