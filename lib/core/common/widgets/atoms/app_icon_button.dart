import 'package:flutter/material.dart';
import 'package:blogapps/core/theme/app_effects.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(12),
      color: backgroundColor,
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
