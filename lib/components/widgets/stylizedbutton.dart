import 'package:flutter/material.dart';

class StylizedButton extends StatelessWidget {
  final String label;
  final IconData? icon; // Make icon optional
  final IconData? iconRight;
  final Function()? onPressed;
  final double? height; // Added height parameter
  final double? width; // Added width parameter
  final double? fontsize; // Added width parameter
  final Color? startColor; // Added startColor parameter
  final Color? endColor; // Added endColor parameter
  final Color? fontColor; // Added endColor parameter
  StylizedButton({
    required this.label,
    this.icon, // Allow null for icon
    this.iconRight,
    required this.onPressed,
    this.height, // Initialize height parameter
    this.width, // Initialize width parameter// Added width parameter
    this.fontsize, // Initialize width parameter// Added width parameter
    this.startColor, // Initialize startColor parameter
    this.endColor, // Initialize endColor parameter
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50, // Use height parameter if provided, else use 50
      width:
          width ?? 200, // Use width parameter if provided, else use full width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            startColor ?? Color(0xFF0072FF),
            endColor ?? Color(0xFF6F74DD)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: (endColor ?? Color(0xFF6F74DD)).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(width: 8), // Adjust the spacing between icon and text
              ],
              Text(
                label,
                style: TextStyle(
                  color: fontColor??Colors.white,
                  fontSize: fontsize ?? 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(width: 8),
                   if (iconRight != null) ...[
                Icon(
                  iconRight,
                  color: Colors.white,
                ),
                SizedBox(width: 5), // Adjust the spacing between icon and text
              ],
            ],
          ),
        ),
      ),
    );
  }
}
