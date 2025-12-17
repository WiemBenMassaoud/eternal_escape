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
  final VoidCallback? onReservationUpdated;

  const ReservationDetailScreen({
    Key? key,
    required this.reservation,
    this.onReservationUpdated,
  }) : super(key: key);

  @override
  State<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  Logement? logement;
  bool _isCancelling = false;

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
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (logement == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Détails de la réservation'),
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
        title: Text('Détails de la réservation'),
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        actions: [
          if (widget.reservation.status == 'confirmed' && widget.reservation.dateFin.isAfter(DateTime.now()))
            IconButton(
              icon: Icon(Icons.cancel_rounded, color: AppTheme.error),
              onPressed: _showCancelDialog,
              tooltip: 'Annuler la réservation',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingXL),
                    decoration: BoxDecoration(
                      gradient: widget.reservation.status == 'confirmed' 
                          ? AppTheme.primaryGradient 
                          : widget.reservation.status == 'cancelled'
                            ? LinearGradient(
                                colors: [AppTheme.error, Color(0xFFD32F2F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [AppTheme.warning, Color(0xFFFF9800)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.reservation.status == 'confirmed' 
                          ? Icons.confirmation_number_rounded
                          : widget.reservation.status == 'cancelled'
                            ? Icons.cancel_rounded
                            : Icons.schedule_rounded,
                      size: 50,
                      color: AppTheme.textLight,
                    ),
                  ),
                  SizedBox(height: AppTheme.marginLG),
                  Text(
                    'Réservation #${widget.reservation.key ?? 0}',
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
                                  'Votre séjour commence bientôt',
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

                  _buildSectionTitle('Détails du séjour', Icons.calendar_today_rounded),
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
                                    'Arrivée',
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
                                    'Départ',
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
                          'Durée totale: $nights nuit${nights > 1 ? 's' : ''}',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.marginXXL),

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

                        if (widget.reservation.nbEnfants3a17 > 0) ...[
                          _buildGuestRow(
                            icon: Icons.child_care_rounded,
                            iconColor: AppTheme.accentDark,
                            label: 'Enfants',
                            count: widget.reservation.nbEnfants3a17,
                            description: '3 à 17 ans (demi-tarif)',
                          ),
                          if (widget.reservation.nbEnfantsMoins3 > 0)
                            SizedBox(height: AppTheme.marginLG),
                        ],

                        if (widget.reservation.nbEnfantsMoins3 > 0)
                          _buildGuestRow(
                            icon: Icons.baby_changing_station_rounded,
                            iconColor: AppTheme.success,
                            label: 'Bébés',
                            count: widget.reservation.nbEnfantsMoins3,
                            description: 'Moins de 3 ans (gratuit)',
                            isGratuit: true,
                          ),

                        SizedBox(height: AppTheme.marginLG),
                        
                        Divider(color: AppTheme.borderLight),
                        
                        SizedBox(height: AppTheme.marginLG),

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

                  _buildSectionTitle('Détails du paiement', Icons.payments_rounded),
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

                  if (widget.reservation.status == 'confirmed' && widget.reservation.dateFin.isAfter(DateTime.now())) ...[
                    _isCancelling
                        ? Container(
                            padding: EdgeInsets.all(AppTheme.paddingLG),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.error),
                                  ),
                                ),
                                SizedBox(width: AppTheme.marginMD),
                                Text(
                                  'Annulation en cours...',
                                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CustomButton(
                            text: 'Annuler la réservation',
                            variant: ButtonVariant.danger,
                            size: ButtonSize.large,
                            isFullWidth: true,
                            icon: Icons.cancel_rounded,
                            onPressed: _showCancelDialog,
                          ),
                    SizedBox(height: AppTheme.marginLG),
                  ],

                  if (widget.reservation.status == 'pending') ...[
                    CustomButton(
                      text: 'Procéder au paiement',
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

                  // BOUTONS "PARTAGER" ET "CONTACTER" SUPPRIMÉS ICI

                  if (widget.reservation.status == 'cancelled') ...[
                    SizedBox(height: AppTheme.marginLG),
                    CustomButton(
                      text: 'Retour aux réservations',
                      variant: ButtonVariant.primary,
                      size: ButtonSize.large,
                      isFullWidth: true,
                      icon: Icons.arrow_back_rounded,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
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
        badgeText = 'Confirmée';
        badgeIcon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        badgeColor = AppTheme.error;
        badgeText = 'Annulée';
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
                'Annuler la réservation ?',
                style: AppTheme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.marginLG),
              Container(
                padding: EdgeInsets.all(AppTheme.paddingMD),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppTheme.error, size: 20),
                    SizedBox(width: AppTheme.marginMD),
                    Expanded(
                      child: Text(
                        'La réservation sera déplacée vers l\'onglet "Annulé"',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        Navigator.pop(context);
                        await _cancelReservation();
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

  Future<void> _cancelReservation() async {
    setState(() {
      _isCancelling = true;
    });

    try {
      widget.reservation.status = 'cancelled';
      widget.reservation.cancelledAt = DateTime.now();
      
      await widget.reservation.save();
      
      print('✅ Réservation annulée avec succès: ${widget.reservation.key}');
      
      if (widget.onReservationUpdated != null) {
        widget.onReservationUpdated!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: AppTheme.marginMD),
              Text('Réservation annulée avec succès'),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _isCancelling = false;
      });

      await Future.delayed(Duration(milliseconds: 500));
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

    } catch (e) {
      print('❌ Erreur lors de l\'annulation: $e');
      
      setState(() {
        _isCancelling = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'annulation: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }
}