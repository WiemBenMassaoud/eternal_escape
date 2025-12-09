import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PriceBreakdownCard extends StatelessWidget {
  final double pricePerNight;
  final int numberOfNights;
  final double serviceFee;
  final double cleaningFee;
  final double? discount;

  const PriceBreakdownCard({
    Key? key,
    required this.pricePerNight,
    required this.numberOfNights,
    this.serviceFee = 0,
    this.cleaningFee = 0,
    this.discount,
  }) : super(key: key);

  double get subtotal => pricePerNight * numberOfNights;
  double get total => subtotal + serviceFee + cleaningFee - (discount ?? 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails du prix',
            style: AppTheme.textTheme.titleLarge,
          ),
          SizedBox(height: AppTheme.marginXL),
          
          _buildPriceRow(
            '$pricePerNight DT x $numberOfNights nuit${numberOfNights > 1 ? 's' : ''}',
            subtotal,
          ),
          
          if (serviceFee > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Frais de service', serviceFee),
          ],
          
          if (cleaningFee > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Frais de ménage', cleaningFee),
          ],
          
          if (discount != null && discount! > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Réduction', -discount!, isDiscount: true),
          ],
          
          SizedBox(height: AppTheme.marginLG),
          Divider(color: AppTheme.borderLight),
          SizedBox(height: AppTheme.marginLG),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)} DT',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} DT',
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: isDiscount ? AppTheme.success : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}