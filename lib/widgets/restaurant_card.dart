import 'package:flutter/material.dart';
import '../theme.dart';

class RestaurantCard extends StatelessWidget {
  final String title;
  final String image;
  final String eta;
  final String fee;
  final double rating;
  final int count;
  final String distance;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.title,
    required this.image,
    required this.eta,
    required this.fee,
    required this.rating,
    required this.count,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: kCardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kPrimary.withValues(alpha: 0.05), // ✅ FIXED
          highlightColor: kPrimary.withValues(alpha: 0.02), // ✅ FIXED
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: Icon(Icons.image_not_supported,
                          size: 48, color: Colors.grey.shade400),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$eta • $fee',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 18, color: kStar),
                        const SizedBox(width: 4),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextDark,
                          ),
                        ),
                        Text(
                          ' ($count)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          ' • $distance',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
