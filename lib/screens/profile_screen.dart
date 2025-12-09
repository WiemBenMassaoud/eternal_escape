import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box<User>('users');
    var logementBox = Hive.box<Logement>('logements');

    // Premier utilisateur pour cette démo
    User user = userBox.isNotEmpty
        ? userBox.getAt(0)!
        : User(
            prenom: "John",
            nom: "Doe",
            email: "john.doe@example.com",
            telephone: "+216 12 345 678",
          );

    return Scaffold(
      backgroundColor: AppTheme.backgroundAlt,
      body: CustomScrollView(
        slivers: [
          // AppBar avec design moderne
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: AppTheme.backgroundLight,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withOpacity(0.1),
                      AppTheme.accentLight.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
              title: Text(
                'Mon Profil',
                style: AppTheme.textTheme.headlineMedium,
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // En-tête avec photo et infos utilisateur
                Container(
                  color: AppTheme.backgroundLight,
                  child: ProfileHeader(
                    name: user.nomComplet,
                    email: user.email,
                    imageUrl: user.photoProfil,
                    onEditPressed: () {
                      _showEditProfileDialog(context, user);
                    },
                  ),
                ),

                SizedBox(height: AppTheme.marginXL),

                // Statistiques
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.paddingXXL),
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<Reservation>('reservations').listenable(),
                    builder: (context, Box<Reservation> resBox, _) {
                      final userReservations = resBox.values
                          .where((r) => r.utilisateurEmail == user.email)
                          .toList();
                      
                      final upcoming = userReservations.where((r) => r.isUpcoming).length;
                      final completed = userReservations.where((r) => r.isCompleted).length;
                      final cancelled = userReservations.where((r) => r.isCancelled).length;

                      return Row(
                        children: [
                          StatCard(
                            icon: Icons.calendar_today_rounded,
                            value: upcoming.toString(),
                            label: 'À venir',
                            iconColor: AppTheme.primary,
                          ),
                          SizedBox(width: AppTheme.marginMD),
                          StatCard(
                            icon: Icons.check_circle_rounded,
                            value: completed.toString(),
                            label: 'Terminées',
                            iconColor: AppTheme.success,
                          ),
                          SizedBox(width: AppTheme.marginMD),
                          StatCard(
                            icon: Icons.cancel_rounded,
                            value: cancelled.toString(),
                            label: 'Annulées',
                            iconColor: AppTheme.error,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: AppTheme.marginXXL),

                // Menu du profil
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.paddingXXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations personnelles',
                        style: AppTheme.textTheme.titleLarge,
                      ),
                      SizedBox(height: AppTheme.marginLG),

                      ProfileMenuItem(
                        icon: Icons.email_rounded,
                        title: 'Email',
                        subtitle: user.email,
                        onTap: () {},
                        showArrow: false,
                      ),

                      ProfileMenuItem(
                        icon: Icons.phone_rounded,
                        title: 'Téléphone',
                        subtitle: user.telephone,
                        onTap: () {},
                        showArrow: false,
                      ),

                      ProfileMenuItem(
                        icon: Icons.location_on_rounded,
                        title: 'Adresse',
                        subtitle: user.adresse.isNotEmpty ? user.adresse : 'Non renseignée',
                        onTap: () {},
                        showArrow: false,
                      ),

                      SizedBox(height: AppTheme.marginXXL),

                      Text(
                        'Paramètres',
                        style: AppTheme.textTheme.titleLarge,
                      ),
                      SizedBox(height: AppTheme.marginLG),

                      ProfileMenuItem(
                        icon: Icons.edit_rounded,
                        title: 'Modifier le profil',
                        onTap: () {
                          _showEditProfileDialog(context, user);
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.lock_rounded,
                        title: 'Changer le mot de passe',
                        onTap: () {
                          _showChangePasswordDialog(context);
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: AppTheme.primary,
                        ),
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: Icons.language_rounded,
                        title: 'Langue',
                        subtitle: 'Français',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: Icons.help_rounded,
                        title: 'Aide et support',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: Icons.privacy_tip_rounded,
                        title: 'Politique de confidentialité',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: Icons.logout_rounded,
                        title: 'Déconnexion',
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        isDestructive: true,
                        showArrow: false,
                      ),

                      SizedBox(height: AppTheme.marginXXL),

                      // Version de l'app
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ),

                      SizedBox(height: AppTheme.marginXXL),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    final prenomController = TextEditingController(text: user.prenom);
    final nomController = TextEditingController(text: user.nom);
    final telephoneController = TextEditingController(text: user.telephone);
    final adresseController = TextEditingController(text: user.adresse);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Text(
          'Modifier le profil',
          style: AppTheme.textTheme.headlineMedium,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
              TextField(
                controller: nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
              TextField(
                controller: adresseController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  prefixIcon: Icon(Icons.location_on_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              user.prenom = prenomController.text;
              user.nom = nomController.text;
              user.telephone = telephoneController.text;
              user.adresse = adresseController.text;
              user.save();
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profil mis à jour avec succès'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: Icon(Icons.lock_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
              ),
            ),
            SizedBox(height: AppTheme.marginMD),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
              ),
            ),
            SizedBox(height: AppTheme.marginMD),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                prefixIcon: Icon(Icons.lock_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mot de passe mis à jour'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.error),
            SizedBox(width: AppTheme.marginMD),
            Text('Déconnexion'),
          ],
        ),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implémenter la déconnexion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Déconnexion réussie'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}