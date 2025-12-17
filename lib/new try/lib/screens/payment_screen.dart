import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  final _paypalEmailController = TextEditingController();
  final _paypalPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _paypalEmailController.dispose();
    _paypalPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nights = widget.reservation.dateFin.difference(widget.reservation.dateDebut).inDays;
    final pricePerNight = (widget.reservation.prixTotal - 
                          (widget.reservation.serviceFee ?? 0) - 
                          (widget.reservation.cleaningFee ?? 0)) / nights;

    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      appBar: AppBar(
        title: Text('Paiement'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  Text(
                    'Finaliser votre réservation',
                    style: AppTheme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppTheme.marginSM),
                  Text(
                    widget.logement.nom,
                    style: AppTheme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceBreakdownCard(
                      pricePerNight: pricePerNight,
                      numberOfNights: nights,
                      serviceFee: widget.reservation.serviceFee ?? 0,
                      cleaningFee: widget.reservation.cleaningFee ?? 0,
                      nbAdults: widget.reservation.nbAdultes,
                      nbChildren3to17: widget.reservation.nbEnfants3a17,
                      nbChildrenUnder3: widget.reservation.nbEnfantsMoins3,
                    ),
                    SizedBox(height: AppTheme.marginXXL),

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

                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _buildPaymentForm(),
                    ),

                    SizedBox(height: AppTheme.marginXXL),

                    _buildPaymentInfoSection(),

                    SizedBox(height: AppTheme.marginXXL),

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
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPaymentForm() {
    switch (selectedPaymentMethod) {
      case 'credit_card':
        return _buildCreditCardForm();
      case 'paypal':
        return _buildPayPalForm();
      case 'cash':
        return _buildCashPaymentInfo();
      default:
        return SizedBox();
    }
  }

  Widget _buildCreditCardForm() {
    return Container(
      key: ValueKey('credit_card'),
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: AppTheme.primary),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Informations de la carte',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),

          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'Numéro de carte',
              hintText: '1234 5678 9012 3456',
              prefixIcon: Icon(Icons.credit_card_rounded, color: AppTheme.primary),
              suffixIcon: _buildCardTypeIcon(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le numéro de carte';
              }
              if (value.replaceAll(' ', '').length < 16) {
                return 'Numéro de carte invalide';
              }
              return null;
            },
          ),
          SizedBox(height: AppTheme.marginLG),

          TextFormField(
            controller: _cardHolderController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Nom du titulaire',
              hintText: 'JOHN DOE',
              prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom du titulaire';
              }
              return null;
            },
          ),
          SizedBox(height: AppTheme.marginLG),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryDateFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Date d\'expiration',
                    hintText: 'MM/AA',
                    prefixIcon: Icon(Icons.calendar_today_rounded, color: AppTheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      borderSide: BorderSide(color: AppTheme.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      borderSide: BorderSide(color: AppTheme.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    if (value.length < 5) {
                      return 'Format MM/AA';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppTheme.marginLG),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: AppTheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      borderSide: BorderSide(color: AppTheme.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      borderSide: BorderSide(color: AppTheme.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    if (value.length < 3) {
                      return '3 chiffres';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Container(
      key: ValueKey('paypal'),
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance, color: Color(0xFF0070BA)),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Connexion PayPal',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),

          TextFormField(
            controller: _paypalEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email PayPal',
              hintText: 'votre@email.com',
              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF0070BA)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: Color(0xFF0070BA), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email PayPal';
              }
              if (!value.contains('@')) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          SizedBox(height: AppTheme.marginLG),

          TextFormField(
            controller: _paypalPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock_outline_rounded, color: Color(0xFF0070BA)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                borderSide: BorderSide(color: Color(0xFF0070BA), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre mot de passe';
              }
              return null;
            },
          ),
          SizedBox(height: AppTheme.marginMD),

          Container(
            padding: EdgeInsets.all(AppTheme.paddingMD),
            decoration: BoxDecoration(
              color: Color(0xFF0070BA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF0070BA), size: 20),
                SizedBox(width: AppTheme.marginMD),
                Expanded(
                  child: Text(
                    'Vous serez redirigé vers PayPal pour finaliser le paiement',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: Color(0xFF0070BA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashPaymentInfo() {
    return Container(
      key: ValueKey('cash'),
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        children: [
          Icon(Icons.money_rounded, size: 60, color: AppTheme.success),
          SizedBox(height: AppTheme.marginLG),
          Text(
            'Paiement à l\'arrivée',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppTheme.marginMD),
          Text(
            'Vous pourrez payer directement à votre arrivée par espèces ou carte bancaire.',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.marginXL),
          Container(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildCashInfoRow(Icons.check_circle_outline, 'Aucun prépaiement requis'),
                SizedBox(height: AppTheme.marginMD),
                _buildCashInfoRow(Icons.calendar_today, 'Réservation garantie'),
                SizedBox(height: AppTheme.marginMD),
                _buildCashInfoRow(Icons.cancel, 'Annulation gratuite 24h avant'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.success),
        SizedBox(width: AppTheme.marginMD),
        Expanded(
          child: Text(
            text,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardTypeIcon() {
    String cardNumber = _cardNumberController.text.replaceAll(' ', '');
    if (cardNumber.isEmpty) return SizedBox();

    IconData icon;
    Color color;

    if (cardNumber.startsWith('4')) {
      icon = Icons.credit_card;
      color = Color(0xFF1A1F71); // Visa
    } else if (cardNumber.startsWith('5')) {
      icon = Icons.credit_card;
      color = Color(0xFFEB001B); // Mastercard
    } else if (cardNumber.startsWith('3')) {
      icon = Icons.credit_card;
      color = Color(0xFF006FCF); // Amex
    } else {
      return SizedBox();
    }

    return Icon(icon, color: color);
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

  Widget _buildPaymentInfoSection() {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_rounded, color: AppTheme.success, size: 24),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Paiement sécurisé',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginLG),
          _buildInfoRow(
            icon: Icons.shield_rounded,
            text: 'Cryptage SSL 256 bits',
            color: AppTheme.success,
          ),
          SizedBox(height: AppTheme.marginMD),
          _buildInfoRow(
            icon: Icons.verified_user_rounded,
            text: 'Vos données sont protégées',
            color: AppTheme.success,
          ),
          SizedBox(height: AppTheme.marginMD),
          _buildInfoRow(
            icon: Icons.policy_rounded,
            text: 'Politique de remboursement disponible',
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: AppTheme.marginMD),
        Expanded(
          child: Text(
            text,
            style: AppTheme.textTheme.bodyMedium,
          ),
        ),
      ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total à payer',
                  style: AppTheme.textTheme.titleMedium,
                ),
                Text(
                  '${widget.reservation.prixTotal.toStringAsFixed(2)} DT',
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.marginLG),
            CustomButton(
              text: isProcessing ? 'Traitement...' : 'Confirmer et payer',
              variant: ButtonVariant.gradient,
              size: ButtonSize.large,
              isFullWidth: true,
              icon: Icons.lock_rounded,
              isLoading: isProcessing,
              onPressed: isProcessing ? null : _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    if (selectedPaymentMethod != 'cash') {
      if (!_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez remplir tous les champs requis'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }
    }

    setState(() => isProcessing = true);
    
    await Future.delayed(Duration(seconds: 2));

    try {
      final reservationBox = Hive.box<Reservation>('reservations');
      
      final confirmedReservation = Reservation(
        logementId: widget.reservation.logementId,
        dateDebut: widget.reservation.dateDebut,
        dateFin: widget.reservation.dateFin,
        prixTotal: widget.reservation.prixTotal,
        utilisateurEmail: widget.reservation.utilisateurEmail,
        status: 'confirmed',
        paymentMethod: selectedPaymentMethod,
        serviceFee: widget.reservation.serviceFee,
        cleaningFee: widget.reservation.cleaningFee,
        nbAdultes: widget.reservation.nbAdultes,
        nbEnfants3a17: widget.reservation.nbEnfants3a17,
        nbEnfantsMoins3: widget.reservation.nbEnfantsMoins3,
        createdAt: DateTime.now(),
      );
      
      await reservationBox.add(confirmedReservation);
      
      print('✅ Réservation confirmée créée avec succès');
      print('📊 Statut: confirmed');

      setState(() => isProcessing = false);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      print('❌ Erreur lors de l\'enregistrement: $e');
      setState(() => isProcessing = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.paddingXXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingXL),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 60,
                  color: AppTheme.textLight,
                ),
              ),
              SizedBox(height: AppTheme.marginXXL),
              Text(
                'Paiement réussi !',
                style: AppTheme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Votre réservation a été confirmée. Vous recevrez un email de confirmation.',
                style: AppTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginLG),
              Container(
                padding: EdgeInsets.all(AppTheme.paddingLG),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: AppTheme.success, size: 20),
                        SizedBox(width: AppTheme.marginMD),
                        Expanded(
                          child: Text(
                            'Réservation #${widget.reservation.logementId}',
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.marginMD),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppTheme.success, size: 20),
                        SizedBox(width: AppTheme.marginMD),
                        Expanded(
                          child: Text(
                            '${widget.reservation.dateDebut.day}/${widget.reservation.dateDebut.month}/${widget.reservation.dateDebut.year} - ${widget.reservation.dateFin.day}/${widget.reservation.dateFin.month}/${widget.reservation.dateFin.year}',
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.marginXXL),
              CustomButton(
                text: 'Voir mes réservations',
                variant: ButtonVariant.primary,
                size: ButtonSize.large,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: AppTheme.marginMD),
              CustomButton(
                text: 'Retour à l\'accueil',
                variant: ButtonVariant.secondary,
                size: ButtonSize.large,
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    
    if (text.isEmpty) {
      return newValue;
    }
    
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}