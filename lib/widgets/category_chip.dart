import 'package:flutter/material.dart';
import '../pages/category_page.dart';
import '../theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String iconAsset;
  final double height;
  final double iconSize;
  final VoidCallback? onTap; // optional callback

  const CategoryChip({
    super.key,
    required this.label,
    required this.iconAsset,
    this.height = 48,
    this.iconSize = 22,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () { 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryPage(
              categoryName: label,
              iconAsset: iconAsset,
            ),
          ),
        );
      },
      child: Container(
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
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
