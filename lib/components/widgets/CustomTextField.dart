import 'package:flutter/material.dart';

class DynamicTextField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final double? height;
  final double? width;
  final double? fontSize;
  final TextEditingController? controller;
  final bool obscureText;
  final String? labelText;
  final String? TextFin;

  DynamicTextField({
    this.hintText,
    this.icon,
    this.height,
    this.width,
    this.fontSize,
    this.controller,
    this.obscureText = false,
    this.labelText,
    this.TextFin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Customize border color
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(fontSize: fontSize ?? 16),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none, // Remove default border
                label: Text(labelText ?? ''),
                
                
                contentPadding: EdgeInsets.all(0.5),
              ),
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: 8),
            Icon(icon),
          ],
        ],
      ),
    );
  }
}
