import 'package:flutter/material.dart';

class CustomInstagramIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomInstagramIcon({super.key, this.size = 28.0, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    final double strokeWidth = size * 0.08;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: .center,
        children: [
          // The Outer Rounded Square
          Container(
            decoration: BoxDecoration(
              borderRadius: .circular(size * 0.25),
              border: .all(color: effectiveColor, width: strokeWidth),
            ),
          ),
          // The Inner Circle (Camera Lens)
          Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: BoxDecoration(
              shape: .circle,
              border: .all(color: effectiveColor, width: strokeWidth),
            ),
          ),
          // The Top Right Dot (Flash/Sensor)
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              // Make the dot slightly thicker than the lines
              width: strokeWidth * 1.2,
              height: strokeWidth * 1.2,
              decoration: BoxDecoration(shape: .circle, color: effectiveColor),
            ),
          ),
        ],
      ),
    );
  }
}
