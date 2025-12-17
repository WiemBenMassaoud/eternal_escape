import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/booking_card.dart';
import 'reservation_details_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1D1D1F), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mes Voyages",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
            letterSpacing: -0.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF007AFF),
          unselectedLabelColor: const Color(0xFF86868B),
          indicatorColor: const Color(0xFF007AFF),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'À venir'),
            Tab(text: 'Terminé'),
            Tab(text: 'Annulé'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList('upcoming'),
          _buildReservationsList('completed'),
          _buildReservationsList('cancelled'),
        ],
      ),
    );
  }
  
  Widget _buildReservationsList(String filterType) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Reservation>('reservations').listenable(),
      builder: (context, Box<Reservation> box, _) {
        final reservations = box.values.toList();
        
        List<Reservation> filteredReservations = [];
        
        switch (filterType) {
          case 'upcoming':
            filteredReservations = reservations
                .where((res) => 
                    res.status == 'confirmed' && 
                    res.dateFin.isAfter(DateTime.now()))
                .toList();
            break;
          case 'completed':
            filteredReservations = reservations
                .where((res) => 
                    res.status == 'confirmed' && 
                    res.dateFin.isBefore(DateTime.now()))
                .toList();
            break;
          case 'cancelled':
            filteredReservations = reservations
                .where((res) => res.status == 'cancelled')
                .toList();
            break;
        }
        
        filteredReservations.sort((a, b) => b.dateDebut.compareTo(a.dateDebut));
        
        if (filteredReservations.isEmpty) {
          return _buildEmptyState(filterType);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filteredReservations.length,
          itemBuilder: (context, index) {
            final reservation = filteredReservations[index];
            final logementBox = Hive.box<Logement>('logements');
            final logement = logementBox.get(reservation.logementId);
            
            if (logement == null) return const SizedBox();
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservationDetailScreen(
                          reservation: reservation,
                          onReservationUpdated: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: BookingCard(
                    reservation: reservation,
                    logementName: logement.nom,
                    logementImage: logement.images.isNotEmpty ? logement.images.first : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservationDetailScreen(
                            reservation: reservation,
                            onReservationUpdated: () {
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildEmptyState(String filterType) {
    IconData icon;
    String title;
    String subtitle;
    
    switch (filterType) {
      case 'upcoming':
        icon = Icons.calendar_today_rounded;
        title = 'Aucun voyage à venir';
        subtitle = 'Vos voyages confirmés à venir apparaîtront ici';
        break;
      case 'completed':
        icon = Icons.history_rounded;
        title = 'Aucun voyage terminé';
        subtitle = 'Vos voyages passés apparaîtront ici';
        break;
      case 'cancelled':
        icon = Icons.cancel_rounded;
        title = 'Aucune réservation annulée';
        subtitle = 'Vos réservations annulées apparaîtront ici';
        break;
      default:
        icon = Icons.search_rounded;
        title = 'Aucune réservation';
        subtitle = 'Commencez à réserver vos voyages';
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF007AFF).withOpacity(0.2),
                    const Color(0xFF34C759).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: const Color(0xFF007AFF),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF86868B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}