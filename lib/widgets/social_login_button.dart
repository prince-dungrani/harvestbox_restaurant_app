import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.white,
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Using colored containers to represent social media icons
    IconData iconData;
    Color iconColor;

    if (iconPath.contains('google')) {
      iconData = Icons.g_mobiledata;
      iconColor = Colors.red;
    } else if (iconPath.contains('facebook')) {
      iconData = Icons.facebook;
      iconColor = Colors.blue;
    } else if (iconPath.contains('apple')) {
      iconData = Icons.apple;
      iconColor = Colors.black;
    } else {
      iconData = Icons.login;
      iconColor = AppTheme.primaryGreen;
    }

    return Icon(iconData, color: iconColor, size: 24);
  }
}
