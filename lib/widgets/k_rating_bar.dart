import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class KRatingBar extends StatelessWidget {
  const KRatingBar({
    super.key,
    required this.rating,
    this.onRatingUpdate,
    this.itemSize = 20,
  });

  final double rating;
  final double itemSize;
  final void Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: onRatingUpdate == null,
      child: RatingBar(
        glow: false,
        itemSize: itemSize,
        initialRating: rating,
        allowHalfRating: false,
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.amber),
          half: const Icon(Icons.star, color: Colors.amber),
          empty: const Icon(Icons.star_border, color: Colors.amber),
        ),
        onRatingUpdate: onRatingUpdate ?? (value) {},
      ),
    );
  }
}
