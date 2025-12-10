import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/booking_card.dart';
import 'reservation_details_screen.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Reservation>('reservations');

    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      appBar: AppBar(
        title: Text("📅 Réservations"),
        backgroundColor: AppTheme.primary,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Reservation> reservations, _) {
          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 80,
                    color: AppTheme.textTertiary,
                  ),
                  SizedBox(height: AppTheme.marginXL),
                  Text(
                    "Aucune réservation",
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppTheme.marginMD),
                  Text(
                    "Vos réservations apparaîtront ici",
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppTheme.paddingLG),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              Reservation res = reservations.getAt(index)!;
              var logementBox = Hive.box<Logement>('logements');
              var logement = logementBox.get(res.logementId);

              if (logement == null) return SizedBox();

              return Dismissible(
                key: Key(res.key.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: AppTheme.paddingXL),
                  margin: EdgeInsets.symmetric(
                    vertical: AppTheme.marginSM,
                    horizontal: AppTheme.marginLG,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.error, AppTheme.error.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                        ),
                        title: Text(
                          'Supprimer la réservation ?',
                          style: AppTheme.textTheme.titleLarge,
                        ),
                        content: Text(
                          'Êtes-vous sûr de vouloir supprimer cette réservation ?',
                          style: AppTheme.textTheme.bodyMedium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.error,
                            ),
                            child: Text('Supprimer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await reservations.deleteAt(index);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: AppTheme.marginMD),
                          Text('Réservation supprimée'),
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
                child: BookingCard(
                  reservation: res,
                  logementName: logement.nom,
                  logementImage: logement.images.isNotEmpty ? logement.images.first : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservationDetailScreen(reservation: res),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}