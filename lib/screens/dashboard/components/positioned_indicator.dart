import 'package:flutter/material.dart';

class PositionedIndicator extends StatelessWidget {
  const PositionedIndicator({
    super.key,
    required this.tourCount,
    required this.backgroundColor,
    this.left,
    this.right,
    this.textColor = Colors.white,
  });

  final int tourCount;
  final Color backgroundColor;
  final double? left;
  final double? right;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (tourCount <= 0) return const SizedBox.shrink();

    return Positioned(
      left: left,
      right: right,
      bottom: 4,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$tourCount',
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}