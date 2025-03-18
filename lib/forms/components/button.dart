import 'package:flutter/material.dart';

enum ButtonStyleType { enable, disable }

class ContinueButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyleType styleType;
  final Icon? icon;
  final isLoading;

  const ContinueButton({
    super.key,
    required this.text,
    this.onPressed,
    this.styleType = ButtonStyleType.enable,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = icon != null; // Check if an icon is provided

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white30,
        child: Ink(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 20), // Add horizontal padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: styleType == ButtonStyleType.enable
                ? LinearGradient(
                    colors: [Colors.cyan.shade300, Colors.cyan],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null, // No gradient for disabled
            color: styleType == ButtonStyleType.disable
                ? Colors.grey.shade200
                : null,
          ),
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      if (hasIcon) ...[
                        icon!,
                        const SizedBox(width: 8), // Space between icon and text
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
