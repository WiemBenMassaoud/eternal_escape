import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/stat_card.dart';
import '../screens/messages_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box<User>('users');
    var logementBox = Hive.box<Logement>('logements');

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
                        icon: Icons.message_rounded,
                        title: 'Messages',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MessagesScreen(),
                            ),
                          );
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.language_rounded,
                        title: 'Paramètres',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.help_rounded,
                        title: 'Aide et support',
                        onTap: () {
                          _showHelpDialog(context);
                        },
                      ),

                      ProfileMenuItem(
                        icon: Icons.privacy_tip_rounded,
                        title: 'Politique de confidentialité',
                        onTap: () {
                          _showPrivacyDialog(context);
                        },
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
              setState(() {});
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
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Text('Changer le mot de passe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
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
                controller: newPasswordController,
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
                controller: confirmPasswordController,
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mot de passe mis à jour'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Les mots de passe ne correspondent pas'),
                    backgroundColor: AppTheme.error,
                  ),
                );
              }
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Row(
          children: [
            Icon(Icons.help_rounded, color: AppTheme.primary),
            SizedBox(width: AppTheme.marginMD),
            Text('Aide et Support'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                'Comment réserver ?',
                'Visitez la section Explorer, sélectionnez un logement et suivez les étapes de réservation.',
              ),
              _buildHelpItem(
                'Comment annuler une réservation ?',
                'Allez dans Voyages, sélectionnez la réservation et cliquez sur Annuler.',
              ),
              _buildHelpItem(
                'Problèmes de paiement ?',
                'Contactez notre équipe support via Messages ou envoyez un email.',
              ),
              _buildHelpItem(
                'Comment modifier mon profil ?',
                'Cliquez sur "Modifier le profil" dans les paramètres.',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: AppTheme.textTheme.bodySmall,
        ),
        SizedBox(height: AppTheme.marginMD),
      ],
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Row(
          children: [
            Icon(Icons.privacy_tip_rounded, color: AppTheme.primary),
            SizedBox(width: AppTheme.marginMD),
            Text('Politique de Confidentialité'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vos données personnelles',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Nous protégeons vos informations personnelles conformément à la RGPD. Vos données sont cryptées et sécurisées.',
                style: AppTheme.textTheme.bodySmall,
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Utilisation des données',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppTheme.marginMD),
              Text(
                'Vos données sont utilisées uniquement pour améliorer votre expérience et traiter vos réservations.',
                style: AppTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: Text('J\'ai compris'),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Déconnexion réussie'),
                  backgroundColor: AppTheme.success,
                ),
              );
              // TODO: Implémenter la vraie déconnexion
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