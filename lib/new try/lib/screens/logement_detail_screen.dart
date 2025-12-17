import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/logement.dart';
import '../models/reservation.dart';
import '../utils/theme.dart';
import '../widgets/amenity_chip.dart';
import '../widgets/custom_button.dart';
import '../widgets/guest_selector_widget.dart';
import '../widgets/room_pension_selector_widget.dart';
import 'payment_screen.dart';
import '../widgets/favorite_button.dart';

class LogementDetailScreen extends StatefulWidget {
  final Logement logement;

  const LogementDetailScreen({Key? key, required this.logement}) : super(key: key);

  @override
  State<LogementDetailScreen> createState() => _LogementDetailScreenState();
}

class _LogementDetailScreenState extends State<LogementDetailScreen> {
  int _currentImageIndex = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  
  int adults = 1;
  int children3to17 = 0;
  int childrenUnder3 = 0;

  int nombreChambres = 1;
  int nombreSuites = 0;
  String selectedPension = 'Sans pension';

  @override
  void initState() {
    super.initState();
    selectedPension = widget.logement.pensionType ?? 
                      widget.logement.getDefaultPensionType();
  }

  double calculateTotalPrice() {
    if (checkInDate == null || checkOutDate == null) return 0;
    
    final nights = checkOutDate!.difference(checkInDate!).inDays;
    final pricePerNight = widget.logement.prix;
    
    double basePrice = nombreChambres * pricePerNight * nights;
    
    if (nombreSuites > 0) {
      double suitePrice = widget.logement.prixSuite ?? 50.0;
      basePrice += nombreSuites * (pricePerNight + suitePrice) * nights;
    }
    
    basePrice *= adults;
    
    if (children3to17 > 0) {
      basePrice += (children3to17 * pricePerNight * 0.5 * nights);
    }
    
    double pensionCost = 0;
    switch (selectedPension) {
      case 'Petit déjeuner':
        pensionCost = basePrice * (widget.logement.type.toLowerCase() == 'hôtel' ? 0.10 : 0.15);
        break;
      case 'Demi-pension':
        pensionCost = basePrice * 0.25;
        break;
      case 'All Inclusive':
        pensionCost = basePrice * 0.45;
        break;
    }
    
    final serviceFee = (basePrice + pensionCost) * 0.10;
    final cleaningFee = 50.0;
    
    return basePrice + pensionCost + serviceFee + cleaningFee;
  }

  double getPensionFee() {
    if (checkInDate == null || checkOutDate == null) return 0;
    
    final nights = checkOutDate!.difference(checkInDate!).inDays;
    final pricePerNight = widget.logement.prix;
    
    double basePrice = nombreChambres * pricePerNight * nights;
    if (nombreSuites > 0) {
      double suitePrice = widget.logement.prixSuite ?? 50.0;
      basePrice += nombreSuites * (pricePerNight + suitePrice) * nights;
    }
    basePrice *= adults;
    if (children3to17 > 0) {
      basePrice += (children3to17 * pricePerNight * 0.5 * nights);
    }
    
    switch (selectedPension) {
      case 'Petit déjeuner':
        return basePrice * (widget.logement.type.toLowerCase() == 'hôtel' ? 0.10 : 0.15);
      case 'Demi-pension':
        return basePrice * 0.25;
      case 'All Inclusive':
        return basePrice * 0.45;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logementId = widget.logement.id ?? (widget.logement.key as int? ?? 0);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(logementId),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Divider(height: 1, color: AppTheme.borderLight),
                _buildMainFeatures(),
                Divider(height: 1, color: AppTheme.borderLight),
                _buildDateSelector(),
                Divider(height: 1, color: AppTheme.borderLight),
                
                Padding(
                  padding: EdgeInsets.all(AppTheme.paddingXXL),
                  child: RoomPensionSelector(
                    logement: widget.logement,
                    initialNombreChambres: nombreChambres,
                    initialNombreSuites: nombreSuites,
                    initialPensionType: selectedPension,
                    onChanged: (chambres, suites, pension) {
                      setState(() {
                        nombreChambres = chambres;
                        nombreSuites = suites;
                        selectedPension = pension;
                      });
                    },
                  ),
                ),
                
                Divider(height: 1, color: AppTheme.borderLight),
                
                Padding(
                  padding: EdgeInsets.all(AppTheme.paddingXXL),
                  child: GuestSelector(
                    initialAdults: adults,
                    initialChildren3to17: children3to17,
                    initialChildrenUnder3: childrenUnder3,
                    onGuestsChanged: (newAdults, newChildren3to17, newChildrenUnder3) {
                      setState(() {
                        adults = newAdults;
                        children3to17 = newChildren3to17;
                        childrenUnder3 = newChildrenUnder3;
                      });
                    },
                  ),
                ),
                
                Divider(height: 1, color: AppTheme.borderLight),
                _buildDescription(),
                Divider(height: 1, color: AppTheme.borderLight),
                _buildAmenities(),
                SizedBox(height: AppTheme.marginXXXL * 2),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBookingBar(),
    );
  }

  Widget _buildSliverAppBar(int logementId) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppTheme.backgroundLight,
      leading: Container(
        margin: EdgeInsets.all(AppTheme.marginSM),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          shape: BoxShape.circle,
          boxShadow: AppTheme.shadowLight,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(AppTheme.marginSM),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            shape: BoxShape.circle,
            boxShadow: AppTheme.shadowLight,
          ),
          child: FavoriteButton(
            logementId: logementId,
            type: 'logement',
            size: 24,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          itemCount: widget.logement.images.length,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemBuilder: (context, index) {
            return Image.asset(
              widget.logement.images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.backgroundAlt,
                  child: Icon(Icons.home_rounded, size: 80, color: AppTheme.textTertiary),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMD,
              vertical: AppTheme.paddingXS,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
            ),
            child: Text(
              widget.logement.type,
              style: AppTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppTheme.marginMD),
          Text(widget.logement.nom, style: AppTheme.textTheme.displaySmall),
          SizedBox(height: AppTheme.marginMD),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingXS),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                ),
                child: Icon(Icons.location_on_rounded, size: AppTheme.iconSM, color: AppTheme.primary),
              ),
              SizedBox(width: AppTheme.marginSM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.logement.ville, style: AppTheme.textTheme.titleMedium),
                    Text(widget.logement.adresse, style: AppTheme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeatures() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Caractéristiques', style: AppTheme.textTheme.titleLarge),
          SizedBox(height: AppTheme.marginLG),
          Row(
            children: [
              _buildFeatureCard(
                icon: Icons.bed_rounded,
                value: widget.logement.nombreChambres.toString(),
                label: 'Chambre${widget.logement.nombreChambres > 1 ? 's' : ''}',
              ),
              SizedBox(width: AppTheme.marginLG),
              _buildFeatureCard(
                icon: Icons.bathroom_rounded,
                value: widget.logement.nombreSallesBain.toString(),
                label: 'Salle${widget.logement.nombreSallesBain > 1 ? 's' : ''} de bain',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppTheme.paddingLG),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.paddingSM),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXS),
              ),
              child: Icon(icon, color: AppTheme.textLight, size: AppTheme.iconMD),
            ),
            SizedBox(height: AppTheme.marginSM),
            Text(value, style: AppTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            Text(label, style: AppTheme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: EdgeInsets.all(AppTheme.paddingXXL),
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
              Container(
                padding: EdgeInsets.all(AppTheme.paddingSM),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Sélectionner les dates',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),
          
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Arrivée',
                  date: checkInDate,
                  onTap: () => _selectCheckInDate(context),
                ),
              ),
              SizedBox(width: AppTheme.marginLG),
              Expanded(
                child: _buildDateField(
                  label: 'Départ',
                  date: checkOutDate,
                  onTap: () => _selectCheckOutDate(context),
                ),
              ),
            ],
          ),
          
          if (checkInDate != null && checkOutDate != null) ...[
            SizedBox(height: AppTheme.marginLG),
            Container(
              padding: EdgeInsets.all(AppTheme.paddingMD),
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
                    '${checkOutDate!.difference(checkInDate!).inDays} nuit${checkOutDate!.difference(checkInDate!).inDays > 1 ? 's' : ''}',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      child: Container(
        padding: EdgeInsets.all(AppTheme.paddingLG),
        decoration: BoxDecoration(
          color: AppTheme.backgroundAlt,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(
            color: date != null ? AppTheme.primary : AppTheme.borderLight,
            width: date != null ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: AppTheme.marginSM),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Sélectionner',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: date != null ? AppTheme.textPrimary : AppTheme.textTertiary,
                fontWeight: date != null ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTheme.textTheme.titleLarge),
          SizedBox(height: AppTheme.marginMD),
          Text(
            widget.logement.description,
            style: AppTheme.textTheme.bodyLarge?.copyWith(height: 1.6, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    final amenities = [
      {'icon': Icons.wifi, 'label': 'WiFi'},
      {'icon': Icons.local_parking, 'label': 'Parking'},
      {'icon': Icons.pool, 'label': 'Piscine'},
      {'icon': Icons.kitchen, 'label': 'Cuisine'},
    ];

    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Équipements', style: AppTheme.textTheme.titleLarge),
          SizedBox(height: AppTheme.marginLG),
          Wrap(
            spacing: AppTheme.marginMD,
            runSpacing: AppTheme.marginMD,
            children: amenities.map((amenity) {
              return AmenityChip(
                icon: amenity['icon'] as IconData,
                label: amenity['label'] as String,
                isAvailable: true,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingBar() {
    final totalPrice = calculateTotalPrice();
    final canBook = checkInDate != null && 
                    checkOutDate != null && 
                    totalPrice > 0;

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
            if (canBook) ...[
              Container(
                padding: EdgeInsets.all(AppTheme.paddingLG),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people_rounded, 
                                 size: 18, 
                                 color: AppTheme.primary),
                            SizedBox(width: AppTheme.marginSM),
                            Text(
                              'Voyageurs',
                              style: AppTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Text(
                          '${adults + children3to17 + childrenUnder3} ${adults + children3to17 + childrenUnder3 > 1 ? 'personnes' : 'personne'}',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppTheme.marginMD),
                    Divider(color: AppTheme.borderLight),
                    SizedBox(height: AppTheme.marginMD),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${totalPrice.toStringAsFixed(2)} DT',
                          style: AppTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.marginLG),
            ],
            
            CustomButton(
              text: canBook ? 'Réserver' : 'Sélectionner les dates',
              variant: ButtonVariant.gradient,
              size: ButtonSize.large,
              isFullWidth: true,
              icon: canBook ? Icons.check_circle_rounded : Icons.calendar_today_rounded,
              onPressed: canBook ? _proceedToReservation : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.textLight,
              surface: AppTheme.backgroundLight,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        checkInDate = picked;
        if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
          checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez d\'abord sélectionner la date d\'arrivée'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate ?? checkInDate!.add(Duration(days: 1)),
      firstDate: checkInDate!.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.textLight,
              surface: AppTheme.backgroundLight,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  void _proceedToReservation() {
    if (checkInDate == null || checkOutDate == null) return;

    final nights = checkOutDate!.difference(checkInDate!).inDays;
    final pricePerNight = widget.logement.prix;
    
    double subtotal = nombreChambres * pricePerNight * nights;
    if (nombreSuites > 0) {
      double suitePrice = widget.logement.prixSuite ?? 50.0;
      subtotal += nombreSuites * (pricePerNight + suitePrice) * nights;
    }
    subtotal *= adults;
    if (children3to17 > 0) {
      subtotal += children3to17 * (pricePerNight * 0.5) * nights;
    }
    
    final pensionFee = getPensionFee();
    final serviceFee = (subtotal + pensionFee) * 0.10;
    final cleaningFee = 50.0;
    final total = subtotal + pensionFee + serviceFee + cleaningFee;

    final reservation = Reservation(
      logementId: widget.logement.key as int,
      dateDebut: checkInDate!,
      dateFin: checkOutDate!,
      prixTotal: total,
      serviceFee: serviceFee,
      cleaningFee: cleaningFee,
      nbAdultes: adults,
      nbEnfants3a17: children3to17,
      nbEnfantsMoins3: childrenUnder3,
      nombreChambresReservees: nombreChambres,
      nombreSuites: nombreSuites,
      pensionType: selectedPension,
      pensionFee: pensionFee,
      utilisateurEmail: "demo@escape.com",
      status: 'pending',
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          reservation: reservation,
          logement: widget.logement,
        ),
      ),
    );
  }
}