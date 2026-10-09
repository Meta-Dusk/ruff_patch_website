import 'package:flutter/material.dart';

class CustomYoutubeIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomYoutubeIcon({super.key, this.size = 28.0, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;
    final triangleColor = colorScheme.onPrimary;

    return SizedBox(
      width: size,
      height: size * 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: .circular(size * 0.22),
        ),
        child: Center(
          child: Icon(
            Icons.play_arrow,
            color: triangleColor,
            size: size * 0.55,
          ),
        ),
      ),
    );
  }
}
