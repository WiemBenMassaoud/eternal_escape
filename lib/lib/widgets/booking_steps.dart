import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BookingSteps extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;

  const BookingSteps({
    Key? key,
    required this.currentStep,
    this.stepTitles = const ['Dates', 'Détails', 'Paiement', 'Confirmation'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.paddingXXL,
        horizontal: AppTheme.paddingLG,
      ),
      child: Row(
        children: List.generate(
          stepTitles.length,
          (index) {
            bool isCompleted = index < currentStep;
            bool isCurrent = index == currentStep;
            bool isLast = index == stepTitles.length - 1;

            return Expanded(
              child: Row(
                children: [
                  // Step circle
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isCompleted || isCurrent
                                ? AppTheme.primaryGradient
                                : null,
                            color: isCompleted || isCurrent
                                ? null
                                : AppTheme.backgroundAlt,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: isCurrent ? AppTheme.shadowCard : null,
                          ),
                          child: Center(
                            child: isCompleted
                                ? Icon(
                                    Icons.check_rounded,
                                    color: AppTheme.textLight,
                                    size: AppTheme.iconMD,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                      color: isCurrent || isCompleted
                                          ? AppTheme.textLight
                                          : AppTheme.textTertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: AppTheme.marginSM),
                        Text(
                          stepTitles[index],
                          style: AppTheme.textTheme.labelMedium?.copyWith(
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                            color: isCurrent || isCompleted
                                ? AppTheme.primary
                                : AppTheme.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Line connector (if not last)
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: EdgeInsets.only(bottom: 40),
                        decoration: BoxDecoration(
                          gradient: isCompleted
                              ? AppTheme.primaryGradient
                              : null,
                          color: isCompleted ? null : AppTheme.borderLight,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}