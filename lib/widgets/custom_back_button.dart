import 'package:flutter/material.dart';

/// Custom back button widget using the uploaded green circular arrow asset
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/back_button.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
