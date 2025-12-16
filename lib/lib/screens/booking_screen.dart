import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/custom_button.dart';
import '../utils/theme.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar(innerBoxIsScrolled)];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildReservationsList('upcoming'),
            _buildReservationsList('completed'),
            _buildReservationsList('cancelled'),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SLIVER APP BAR
  // ------------------------------------------------------------

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppTheme.backgroundLight,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.1),
                AppTheme.accentLight.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppTheme.paddingMD),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: AppTheme.textLight,
                          size: AppTheme.iconLG,
                        ),
                      ),
                      SizedBox(width: AppTheme.marginLG),
                      Text(
                        'Mes Réservations',
                        style: AppTheme.textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          color: AppTheme.backgroundLight,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppTheme.marginLG),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundAlt,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  labelColor: AppTheme.textLight,
                  unselectedLabelColor: AppTheme.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'À venir'),
                    Tab(text: 'Terminées'),
                    Tab(text: 'Annulées'),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LISTE DES RÉSERVATIONS
  // ------------------------------------------------------------

  Widget _buildReservationsList(String status) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Reservation>('reservations').listenable(),
      builder: (context, Box<Reservation> box, _) {
        final logementBox = Hive.box<Logement>('logements');

        // Filtrage sécurisé
        final filteredReservations = box.values.where((reservation) {
          if (status == 'upcoming') return reservation.isUpcoming;
          if (status == 'completed') return reservation.isCompleted;
          if (status == 'cancelled') return reservation.isCancelled;
          return false;
        }).toList();

        if (filteredReservations.isEmpty) {
          return _buildEmptyState(status);
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppTheme.paddingLG),
          itemCount: filteredReservations.length,
          itemBuilder: (context, index) {
            final reservation = filteredReservations[index];

            // Chargement du logement en toute sécurité
            final logement = logementBox.get(reservation.logementId);

            return BookingCard(
              reservation: reservation,
              logementName: logement?.nom ?? 'Logement inconnu',
              logementImage: (logement?.images.isNotEmpty == true)
                  ? logement!.images.first
                  : null,
              onTap: () => _showReservationDetails(reservation, logement),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATES
  // ------------------------------------------------------------

  Widget _buildEmptyState(String status) {
    switch (status) {
      case 'upcoming':
        return EmptyStateWidget(
          icon: Icons.event_available_rounded,
          title: 'Aucune réservation à venir',
          message:
              'Explorez nos logements et réservez votre prochaine escapade !',
          buttonText: 'Explorer',
          onButtonPressed: () {},
        );

      case 'completed':
        return EmptyStateWidget(
          icon: Icons.history_rounded,
          title: 'Aucun voyage terminé',
          message: 'Vos réservations passées apparaîtront ici',
        );

      default:
        return EmptyStateWidget(
          icon: Icons.event_busy_rounded,
          title: 'Aucune réservation annulée',
          message: 'Les réservations annulées apparaîtront ici',
        );
    }
  }

  // ------------------------------------------------------------
  // DETAILS RÉSERVATION
  // ------------------------------------------------------------

  void _showReservationDetails(Reservation reservation, Logement? logement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusXL),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: AppTheme.marginMD),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusCircle),
                  ),
                ),

                // CONTENU
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(AppTheme.paddingXXL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Réservation #${reservation.key}',
                          style: AppTheme.textTheme.headlineMedium,
                        ),

                        SizedBox(height: AppTheme.marginXL),

                        if (logement != null) ...[
                          Text(logement.nom,
                              style: AppTheme.textTheme.titleLarge),
                          Text('${logement.ville}, ${logement.adresse}'),
                        ],

                        SizedBox(height: AppTheme.marginXL),
                        Text('Prix total: ${reservation.prixTotal} DT'),
                        Text('Statut: ${reservation.status}'),

                        if (reservation.isUpcoming) ...[
                          SizedBox(height: AppTheme.marginXXL),
                          CustomButton(
                            text: 'Annuler la réservation',
                            variant: ButtonVariant.danger,
                            isFullWidth: true,
                            icon: Icons.cancel_rounded,
                            onPressed: () =>
                                _cancelReservation(reservation),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // ANNULATION DE RÉSERVATION
  // ------------------------------------------------------------

  void _cancelReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la réservation ?'),
        content: Text('Êtes-vous sûr de vouloir annuler cette réservation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () async {
              reservation.status = 'cancelled';
              reservation.cancelledAt = DateTime.now();
              await reservation.save();

              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Réservation annulée')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }
}
