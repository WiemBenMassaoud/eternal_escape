import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final Reservation reservation;
  final Logement logement;

  const PaymentScreen({
    Key? key,
    required this.reservation,
    required this.logement,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'credit_card';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final nights = widget.reservation.dateFin.difference(widget.reservation.dateDebut).inDays;
    final pricePerNight = (widget.reservation.prixTotal - widget.reservation.serviceFee! - widget.reservation.cleaningFee!) / nights;

    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      appBar: AppBar(
        title: Text('Paiement'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.1),
                    AppTheme.accentLight.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.payment_rounded, size: 60, color: AppTheme.primary),
                  SizedBox(height: AppTheme.marginMD),
                  Text('Finaliser votre réservation', style: AppTheme.textTheme.headlineMedium, textAlign: TextAlign.center),
                  SizedBox(height: AppTheme.marginSM),
                  Text(widget.logement.nom, style: AppTheme.textTheme.bodyLarge, textAlign: TextAlign.center),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Détails du prix avec PriceBreakdownCard
                  PriceBreakdownCard(
                    pricePerNight: pricePerNight,
                    numberOfNights: nights,
                    serviceFee: widget.reservation.serviceFee ?? 0,
                    cleaningFee: widget.reservation.cleaningFee ?? 0,
                  ),
                  
                  SizedBox(height: AppTheme.marginXXL),

                  // Méthodes de paiement
                  Text('Méthode de paiement', style: AppTheme.textTheme.titleLarge),
                  SizedBox(height: AppTheme.marginLG),

                  _buildPaymentMethod(
                    icon: Icons.credit_card_rounded,
                    title: 'Carte bancaire',
                    subtitle: 'Visa, Mastercard, Amex',
                    value: 'credit_card',
                    iconColor: AppTheme.primary,
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  _buildPaymentMethod(
                    icon: Icons.account_balance_rounded,
                    title: 'PayPal',
                    subtitle: 'Paiement sécurisé',
                    value: 'paypal',
                    iconColor: Color(0xFF0070BA),
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  _buildPaymentMethod(
                    icon: Icons.money_rounded,
                    title: 'Paiement à l\'arrivée',
                    subtitle: 'Espèces ou carte sur place',
                    value: 'cash',
                    iconColor: AppTheme.success,
                  ),

                  SizedBox(height: AppTheme.marginXXL),

                  // Informations
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingLG),
                    decoration: BoxDecoration(
                      color: AppTheme.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      border: Border.all(color: AppTheme.info.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: AppTheme.info),
                        SizedBox(width: AppTheme.marginMD),
                        Expanded(
                          child: Text(
                            'En confirmant, vous acceptez les conditions générales.',
                            style: AppTheme.textTheme.bodySmall?.copyWith(color: AppTheme.info),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color iconColor,
  }) {
    final isSelected = selectedPaymentMethod == value;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.borderLight,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppTheme.shadowCard : AppTheme.shadowLight,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => selectedPaymentMethod = value),
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.paddingMD),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Icon(icon, color: iconColor, size: AppTheme.iconMD),
                ),
                SizedBox(width: AppTheme.marginLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.textTheme.titleMedium),
                      Text(subtitle, style: AppTheme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: selectedPaymentMethod,
                  onChanged: (val) => setState(() => selectedPaymentMethod = val!),
                  activeColor: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: isProcessing ? 'Traitement...' : 'Confirmer et payer',
          variant: ButtonVariant.gradient,
          size: ButtonSize.large,
          isFullWidth: true,
          icon: Icons.lock_rounded,
          isLoading: isProcessing,
          onPressed: isProcessing ? null : _processPayment,
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => isProcessing = true);
    await Future.delayed(Duration(seconds: 2));

    // Sauvegarder la réservation dans Hive
    final reservationBox = Hive.box<Reservation>('reservations');
    widget.reservation.status = 'confirmed';
    widget.reservation.paymentMethod = selectedPaymentMethod;
    await reservationBox.add(widget.reservation);

    setState(() => isProcessing = false);

    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLG)),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.paddingXXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingXL),
                decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, size: 60, color: AppTheme.textLight),
              ),
              SizedBox(height: AppTheme.marginXXL),
              Text('Paiement réussi !', style: AppTheme.textTheme.headlineMedium, textAlign: TextAlign.center),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Votre réservation a été confirmée. Vous recevrez un email de confirmation.',
                style: AppTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginXXL),
              CustomButton(
                text: 'Voir mes réservations',
                variant: ButtonVariant.gradient,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}