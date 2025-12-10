import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/price_breakdown_card.dart';
import 'payment_screen.dart';
import '../widgets/guest_selector_widget.dart';


class ReservationDetailScreen extends StatefulWidget {
  final Reservation reservation;

  const ReservationDetailScreen({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  State<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  Logement? logement;

  @override
  void initState() {
    super.initState();
    _loadLogement();
  }

  void _loadLogement() {
    final logementBox = Hive.box<Logement>('logements');
    setState(() {
      logement = logementBox.get(widget.reservation.logementId);
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'Janvier', 'FÃ©vrier', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'AoÃ»t', 'Septembre', 'Octobre', 'Novembre', 'DÃ©cembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (logement == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('DÃ©tails de la rÃ©servation'),
          backgroundColor: AppTheme.backgroundLight,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final nights = widget.reservation.dateFin.difference(widget.reservation.dateDebut).inDays;
    final pricePerNight = (widget.reservation.prixTotal - 
                          (widget.reservation.serviceFee ?? 0) - 
                          (widget.reservation.cleaningFee ?? 0)) / nights;
    final isUpcoming = widget.reservation.isUpcoming;
    final isPaid = widget.reservation.status == 'confirmed';

    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      appBar: AppBar(
        title: Text('DÃ©tails de la rÃ©servation'),
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tÃªte avec icÃ´ne
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
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingXL),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.confirmation_number_rounded,
                      size: 50,
                      color: AppTheme.textLight,
                    ),
                  ),
                  SizedBox(height: AppTheme.marginLG),
                  Text(
                    'RÃ©servation #${widget.reservation.key ?? 0}',
                    style: AppTheme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppTheme.marginSM),
                  _buildStatusBadge(),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alerte pour les rÃ©servations Ã  venir
                  if (isUpcoming && !isPaid)
                    Container(
                      margin: EdgeInsets.only(bottom: AppTheme.marginXL),
                      padding: EdgeInsets.all(AppTheme.paddingLG),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: AppTheme.warning),
                          SizedBox(width: AppTheme.marginMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'C\'est aujourd\'hui !',
                                  style: AppTheme.textTheme.titleMedium?.copyWith(
                                    color: AppTheme.warning,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Votre sÃ©jour commence bientÃ´t',
                                  style: AppTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Section Logement
                  _buildSectionTitle('Logement', Icons.home_rounded),
                  SizedBox(height: AppTheme.marginLG),
                  
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingLG),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: AppTheme.shadowLight,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                          child: logement!.images.isNotEmpty
                              ? Image.asset(
                                  logement!.images.first,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: AppTheme.backgroundAlt,
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: AppTheme.backgroundAlt,
                                  child: Icon(Icons.home_rounded),
                                ),
                        ),
                        SizedBox(width: AppTheme.marginLG),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                logement!.nom,
                                style: AppTheme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppTheme.marginSM),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${logement!.ville}, ${logement!.adresse}',
                                      style: AppTheme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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

                  SizedBox(height: AppTheme.marginXXL),

                  // Section DÃ©tails du sÃ©jour
                  _buildSectionTitle('DÃ©tails du sÃ©jour', Icons.calendar_today_rounded),
                  SizedBox(height: AppTheme.marginLG),

                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingLG),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: AppTheme.shadowLight,
                    ),
                    child: Column(
                      children: [
                        // ArrivÃ©e
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppTheme.paddingSM),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              ),
                              child: Icon(
                                Icons.flight_land_rounded,
                                color: AppTheme.primary,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: AppTheme.marginLG),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ArrivÃ©e',
                                    style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(widget.reservation.dateDebut),
                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: AppTheme.marginLG),
                        
                        // DÃ©part
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppTheme.paddingSM),
                              decoration: BoxDecoration(
                                color: AppTheme.accentLight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              ),
                              child: Icon(
                                Icons.flight_takeoff_rounded,
                                color: AppTheme.accentDark,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: AppTheme.marginLG),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DÃ©part',
                                    style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(widget.reservation.dateFin),
                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.marginLG),

                  // DurÃ©e totale
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingLG),
                    decoration: BoxDecoration(
                      gradient: AppTheme.promoGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nights_stay_rounded,
                          color: AppTheme.textLight,
                          size: 20,
                        ),
                        SizedBox(width: AppTheme.marginMD),
                        Text(
                          'DurÃ©e totale: $nights nuit${nights > 1 ? 's' : ''}',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.marginXXL),

                  // Section Voyageurs
                  _buildSectionTitle('Voyageurs', Icons.people_rounded),
                  SizedBox(height: AppTheme.marginLG),

                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingLG),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: AppTheme.shadowLight,
                    ),
                    child: Column(
                      children: [
                        // Adultes
                        if (widget.reservation.nbAdultes > 0)
                          _buildGuestRow(
                            icon: Icons.person_rounded,
                            iconColor: AppTheme.primary,
                            label: 'Adultes',
                            count: widget.reservation.nbAdultes,
                            description: '18 ans et plus',
                          ),

                        if (widget.reservation.nbAdultes > 0 && 
                            (widget.reservation.nbEnfants3a17 > 0 || 
                             widget.reservation.nbEnfantsMoins3 > 0))
                          SizedBox(height: AppTheme.marginLG),

                        // Enfants 3-17 ans
                        if (widget.reservation.nbEnfants3a17 > 0) ...[
                          _buildGuestRow(
                            icon: Icons.child_care_rounded,
                            iconColor: AppTheme.accentDark,
                            label: 'Enfants',
                            count: widget.reservation.nbEnfants3a17,
                            description: '3 Ã  17 ans (demi-tarif)',
                          ),
                          if (widget.reservation.nbEnfantsMoins3 > 0)
                            SizedBox(height: AppTheme.marginLG),
                        ],

                        // BÃ©bÃ©s < 3 ans
                        if (widget.reservation.nbEnfantsMoins3 > 0)
                          _buildGuestRow(
                            icon: Icons.baby_changing_station_rounded,
                            iconColor: AppTheme.success,
                            label: 'BÃ©bÃ©s',
                            count: widget.reservation.nbEnfantsMoins3,
                            description: 'Moins de 3 ans (gratuit)',
                            isGratuit: true,
                          ),

                        SizedBox(height: AppTheme.marginLG),
                        
                        Divider(color: AppTheme.borderLight),
                        
                        SizedBox(height: AppTheme.marginLG),

                        // Total voyageurs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppTheme.paddingSM),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.groups_rounded,
                                color: AppTheme.textLight,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: AppTheme.marginMD),
                            Text(
                              'Total: ${widget.reservation.totalGuests} ${widget.reservation.totalGuests > 1 ? 'personnes' : 'personne'}',
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.marginXXL),

                  // Section DÃ©tails du paiement
                  _buildSectionTitle('DÃ©tails du paiement', Icons.payments_rounded),
                  SizedBox(height: AppTheme.marginLG),

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

                  // Boutons d'action
                  if (!isPaid) ...[
                    CustomButton(
                      text: 'ProcÃ©der au paiement',
                      variant: ButtonVariant.gradient,
                      size: ButtonSize.large,
                      isFullWidth: true,
                      icon: Icons.payment_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              reservation: widget.reservation,
                              logement: logement!,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppTheme.marginLG),
                  ],

                  if (isUpcoming)
                    CustomButton(
                      text: 'Annuler la rÃ©servation',
                      variant: ButtonVariant.danger,
                      size: ButtonSize.large,
                      isFullWidth: true,
                      icon: Icons.cancel_rounded,
                      onPressed: _showCancelDialog,
                    ),

                  if (isUpcoming && !isPaid)
                    SizedBox(height: AppTheme.marginLG),

                  CustomButton(
                    text: 'Partager',
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.large,
                    isFullWidth: true,
                    icon: Icons.share_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('FonctionnalitÃ© de partage Ã  venir'),
                          backgroundColor: AppTheme.info,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: AppTheme.marginLG),

                  CustomButton(
                    text: 'Contacter',
                    variant: ButtonVariant.text,
                    size: ButtonSize.large,
                    isFullWidth: true,
                    icon: Icons.message_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('FonctionnalitÃ© de messagerie Ã  venir'),
                          backgroundColor: AppTheme.info,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
    required String description,
    bool isGratuit = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppTheme.paddingSM),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        SizedBox(width: AppTheme.marginLG),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppTheme.marginMD),
        Row(
          children: [
            Text(
              '$count',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
            if (isGratuit) ...[
              SizedBox(width: AppTheme.marginSM),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingSM,
                  vertical: AppTheme.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                  border: Border.all(color: AppTheme.success),
                ),
                child: Text(
                  'GRATUIT',
                  style: AppTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppTheme.paddingSM),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Icon(icon, color: AppTheme.textLight, size: 20),
        ),
        SizedBox(width: AppTheme.marginMD),
        Text(
          title,
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (widget.reservation.status) {
      case 'confirmed':
        badgeColor = AppTheme.success;
        badgeText = 'ConfirmÃ©e';
        badgeIcon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        badgeColor = AppTheme.error;
        badgeText = 'AnnulÃ©e';
        badgeIcon = Icons.cancel_rounded;
        break;
      case 'pending':
      default:
        badgeColor = AppTheme.warning;
        badgeText = 'En attente de paiement';
        badgeIcon = Icons.schedule_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.paddingLG,
        vertical: AppTheme.paddingSM,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 18),
          SizedBox(width: AppTheme.marginSM),
          Text(
            badgeText,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.paddingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingLG),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 50,
                  color: AppTheme.error,
                ),
              ),
              SizedBox(height: AppTheme.marginXL),
              Text(
                'Annuler la rÃ©servation ?',
                style: AppTheme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'ÃŠtes-vous sÃ»r de vouloir annuler cette rÃ©servation ? Cette action est irrÃ©versible.',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginXXL),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Non, garder',
                      variant: ButtonVariant.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: AppTheme.marginLG),
                  Expanded(
                    child: CustomButton(
                      text: 'Oui, annuler',
                      variant: ButtonVariant.danger,
                      onPressed: () async {
                        widget.reservation.status = 'cancelled';
                        widget.reservation.cancelledAt = DateTime.now();
                        await widget.reservation.save();
                        
                        Navigator.pop(context);
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: AppTheme.marginMD),
                                Text('RÃ©servation annulÃ©e avec succÃ¨s'),
                              ],
                            ),
                            backgroundColor: AppTheme.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}