import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ReviewCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date;
  final List<String>? images;

  const ReviewCard({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginLG),
      padding: EdgeInsets.all(AppTheme.paddingLG),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec avatar et note
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(userAvatar),
                backgroundColor: AppTheme.backgroundAlt,
              ),
              SizedBox(width: AppTheme.marginMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: AppTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStarRating(rating),
                        SizedBox(width: AppTheme.marginSM),
                        Text(
                          date,
                          style: AppTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginMD),
          
          // Commentaire
          Text(
            comment,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
          
          // Images si disponibles
          if (images != null && images!.isNotEmpty) ...[
            SizedBox(height: AppTheme.marginMD),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: AppTheme.marginSM),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                      child: Image.asset(
                        images![index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(
            Icons.star,
            size: AppTheme.iconXS,
            color: AppTheme.warning,
          );
        } else if (index < rating) {
          return Icon(
            Icons.star_half,
            size: AppTheme.iconXS,
            color: AppTheme.warning,
          );
        } else {
          return Icon(
            Icons.star_border,
            size: AppTheme.iconXS,
            color: AppTheme.textTertiary,
          );
        }
      }),
    );
  }
}