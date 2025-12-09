import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive_flutter/hive_flutter.dart';
import '../models/logement.dart';
import '../models/reservation.dart';
import '../utils/theme.dart';
import '../widgets/amenity_chip.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';

class LogementDetailScreen extends StatefulWidget {
  final Logement logement;

  const LogementDetailScreen({Key? key, required this.logement}) : super(key: key);

  @override
  State<LogementDetailScreen> createState() => _LogementDetailScreenState();
}

class _LogementDetailScreenState extends State<LogementDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  Widget build(BuildContext context) {
    final nights = _selectedEndDate != null && _selectedStartDate != null
        ? _selectedEndDate!.difference(_selectedStartDate!).inDays
        : 2;
    final serviceFee = widget.logement.prix * 0.1; // 10% frais de service
    final cleaningFee = 30.0; // Frais de ménage fixe
    final subtotal = widget.logement.prix * nights;
    final totalPrice = subtotal + serviceFee + cleaningFee;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Divider(height: 1, color: AppTheme.borderLight),
                _buildMainFeatures(),
                Divider(height: 1, color: AppTheme.borderLight),
                _buildDateSelection(),
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
      bottomNavigationBar: _buildBottomBar(totalPrice, nights, serviceFee, cleaningFee),
    );
  }

  Widget _buildSliverAppBar() {
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
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? AppTheme.primary : AppTheme.textPrimary,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
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

  Widget _buildDateSelection() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sélectionner les dates', style: AppTheme.textTheme.titleLarge),
          SizedBox(height: AppTheme.marginLG),
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: 'Arrivée',
                  date: _selectedStartDate,
                  onTap: () => _selectDate(true),
                ),
              ),
              SizedBox(width: AppTheme.marginMD),
              Expanded(
                child: _buildDateButton(
                  label: 'Départ',
                  date: _selectedEndDate,
                  onTap: () => _selectDate(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton({required String label, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppTheme.paddingLG),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: date != null ? AppTheme.primary : AppTheme.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.textTheme.bodySmall),
            SizedBox(height: 4),
            Text(
              date != null ? _formatDate(date) : 'Sélectionner',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: date != null ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: isStartDate ? 1 : 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          if (_selectedEndDate != null && _selectedEndDate!.isBefore(picked)) {
            _selectedEndDate = null;
          }
        } else {
          if (_selectedStartDate != null && picked.isAfter(_selectedStartDate!)) {
            _selectedEndDate = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('La date de départ doit être après la date d\'arrivée')),
            );
          }
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${date.day} ${months[date.month - 1]}';
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

  Widget _buildBottomBar(double totalPrice, int nights, double serviceFee, double cleaningFee) {
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prix total', style: AppTheme.textTheme.bodySmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${totalPrice.toStringAsFixed(0)}',
                        style: AppTheme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(' DT', style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.primary)),
                    ],
                  ),
                  Text('pour $nights nuit${nights > 1 ? 's' : ''}', style: AppTheme.textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(width: AppTheme.marginLG),
            CustomButton(
              text: 'Réserver',
              variant: ButtonVariant.gradient,
              size: ButtonSize.large,
              icon: Icons.payment_rounded,
              onPressed: () => _navigateToPayment(totalPrice, nights, serviceFee, cleaningFee),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPayment(double totalPrice, int nights, double serviceFee, double cleaningFee) {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner les dates de séjour'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Créer la réservation en statut "pending"
    final reservation = Reservation(
      logementId: widget.logement.key as int,
      dateDebut: _selectedStartDate!,
      dateFin: _selectedEndDate!,
      prixTotal: totalPrice,
      utilisateurEmail: "demo@escape.com", // À remplacer par l'email de l'utilisateur connecté
      status: 'pending',
      serviceFee: serviceFee,
      cleaningFee: cleaningFee,
    );

    // Naviguer vers l'écran de paiement
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