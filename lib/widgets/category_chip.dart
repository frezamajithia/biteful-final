import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String iconAsset;
  final double height;
  final double iconSize;

  const CategoryChip({
    super.key,
    required this.label,
    required this.iconAsset,
    this.height = 48,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: kCardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconAsset,
            height: iconSize,
            width: iconSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kTextDark,
            ),
            overflow: TextOverflow.ellipsis, // ✅ FIXED: was overflow: TextOverflow.fade
            softWrap: false,
          ),
        ],
      ),
    );
  }
}
