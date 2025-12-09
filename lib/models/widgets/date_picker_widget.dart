import 'package:flutter/material.dart';
import '../utils/theme.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerWidget({
    Key? key,
    this.selectedDate,
    required this.onDateSelected,
    required this.label,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.titleSmall,
        ),
        SizedBox(height: AppTheme.marginSM),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          child: Container(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            decoration: BoxDecoration(
              color: AppTheme.backgroundCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.primary,
                  size: AppTheme.iconSM,
                ),
                SizedBox(width: AppTheme.marginMD),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'Sélectionner une date',
                    style: selectedDate != null
                        ? AppTheme.textTheme.bodyLarge
                        : AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppTheme.iconXS,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundLight,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
