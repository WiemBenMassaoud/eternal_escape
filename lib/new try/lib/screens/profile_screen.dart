import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';
import '../../models/preferences.dart';
import '../../models/notification_settings.dart';
import '../screens/messages_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/reservations_screen.dart';
import '../screens/welcome_screen.dart';
import '../services/chat_storage.dart';

// Widgets extraits
import '../widgets/profile_header.dart';
import '../widgets/personal_info_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/settings_section.dart';
import '../widgets/support_section.dart';

// Helpers extraits
import '../utils/profile_dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  late Preferences userPreferences;
  late NotificationSettings notificationSettings;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userBox = Hive.box<User>('users');
      final prefsBox = Hive.box<Preferences>('preferences');
      final notifBox = Hive.box<NotificationSettings>('notification_settings');

      if (userBox.isNotEmpty) {
        currentUser = userBox.getAt(0)!;
        print('✅ Utilisateur chargé: ${currentUser.prenom} ${currentUser.nom}');
      } else {
        print('❌ Aucun utilisateur trouvé dans Hive');
        currentUser = User(
          prenom: "Amal",
          nom: "BenAli",
          email: "benaliamal@example.com",
          telephone: "+216 29 520 140",
          dateNaissance: null,
          photoProfil: 'assets/default_user.png',
          adresse: "Sfax, Tunis",
          reservationsIds: [],
        );
      }

      if (prefsBox.isNotEmpty) {
        userPreferences = prefsBox.getAt(0)!;
      } else {
        userPreferences = Preferences(
          language: 'Français',
          currency: 'TND',
          theme: 'Clair',
          locationServices: true,
          autoSync: true,
          notificationFrequency: 'Immédiate',
          travelClass: 'Économique',
          seatPreference: 'Fenêtre',
          mealPreference: 'Standard',
          hotelType: '3-4 étoiles',
          favoriteDestinations: ['Plage', 'Montagne', 'Ville'],
          averageBudget: '500-1000€',
          favoriteActivities: ['Randonnée', 'Gastronomie', 'Culture'],
        );
        await prefsBox.add(userPreferences);
      }

      if (notifBox.isNotEmpty) {
        notificationSettings = notifBox.getAt(0)!;
      } else {
        notificationSettings = NotificationSettings(
          reservationNotifications: true,
          promotionNotifications: true,
          newsletter: true,
          messageNotifications: true,
          pushNotifications: true,
          emailNotifications: true,
          smsNotifications: false,
          soundEnabled: true,
          vibrationEnabled: true,
          silentHoursEnabled: false,
        );
        await notifBox.add(notificationSettings);
      }

    } catch (e) {
      print('❌ Erreur lors du chargement des données: $e');

      currentUser = User(
        prenom: "Amal",
        nom: "BenAli",
        email: "benaliamal@example.com",
        telephone: "+216 29 520 140",
        dateNaissance: null,
        photoProfil: 'assets/default_user.png',
        adresse: "Sfax, Tunis",
        reservationsIds: [],
      );

      userPreferences = Preferences(
        language: 'Français',
        currency: 'EUR',
        theme: 'Clair',
        locationServices: true,
        autoSync: true,
        notificationFrequency: 'Immédiate',
        travelClass: 'Économique',
        seatPreference: 'Fenêtre',
        mealPreference: 'Standard',
        hotelType: '3-4 étoiles',
        favoriteDestinations: ['Plage', 'Montagne', 'Ville'],
        averageBudget: '500-1000€',
        favoriteActivities: ['Randonnée', 'Gastronomie', 'Culture'],
      );

      notificationSettings = NotificationSettings(
        reservationNotifications: true,
        promotionNotifications: true,
        newsletter: true,
        messageNotifications: true,
        pushNotifications: true,
        emailNotifications: true,
        smsNotifications: false,
        soundEnabled: true,
        vibrationEnabled: true,
        silentHoursEnabled: false,
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      print('🔍 Sauvegarde des paramètres dans profile_screen...');
      
      if (!Hive.isAdapterRegistered(6)) {
        print('⚠️ Adapter manquant, enregistrement...');
        Hive.registerAdapter(NotificationSettingsAdapter());
        await Future.delayed(Duration(milliseconds: 200));
      }
      
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      
      if (!notifBox.isOpen) {
        print('⚠️ Box fermée, réouverture...');
        await Hive.openBox<NotificationSettings>('notification_settings');
      }
      
      final settingsToSave = NotificationSettings(
        reservationNotifications: notificationSettings.reservationNotifications,
        promotionNotifications: notificationSettings.promotionNotifications,
        newsletter: notificationSettings.newsletter,
        messageNotifications: notificationSettings.messageNotifications,
        pushNotifications: notificationSettings.pushNotifications,
        emailNotifications: notificationSettings.emailNotifications,
        smsNotifications: notificationSettings.smsNotifications,
        soundEnabled: notificationSettings.soundEnabled,
        vibrationEnabled: notificationSettings.vibrationEnabled,
        silentHoursEnabled: notificationSettings.silentHoursEnabled,
      );
      
      await notifBox.put(0, settingsToSave);
      
      final saved = notifBox.get(0);
      if (saved != null) {
        print('✅ SUCCÈS COMPLET: Paramètres sauvegardés et vérifiés!');
      }
      
      await Future.delayed(Duration(milliseconds: 100));
      
    } catch (e, stack) {
      print('❌ ERREUR FATALE lors de la sauvegarde:');
      print('Erreur: $e');
      print('Stack trace: $stack');
      print('⚠️ Erreur capturée, continuation...');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefsBox = Hive.box<Preferences>('preferences');
      if (prefsBox.isNotEmpty) {
        await prefsBox.putAt(0, userPreferences);
      } else {
        await prefsBox.add(userPreferences);
      }
    } catch (e) {
      print('Erreur sauvegarde préférences: $e');
      rethrow;
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isError
                      ? [
                          const Color(0xFFFF3B58),
                          const Color(0xFFEC407A),
                        ]
                      : [
                          const Color(0xFF06D6A0),
                          const Color(0xFF4ACFB0),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.error_outline_rounded : Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1D1D1F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        duration: Duration(seconds: isError ? 4 : 2),
        margin: EdgeInsets.all(20),
        elevation: 4,
      ),
    );
  }

  // ---- helpers used by child widgets (callbacks) ----

  void _onEditProfile() {
    ProfileDialogs.showEditProfileDialog(
      context,
      currentUser: currentUser,
      onSave: () {
        if (mounted) setState(() {});
        _showSnackbar('Profil mis à jour avec succès!');
      },
    );
  }

  void _onOpenReservations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationsScreen(),
      ),
    );
  }

  void _onOpenNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsScreen(),
      ),
    );
  }

  void _onOpenMessages() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC407A).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEC407A),
                        const Color(0xFFF06292),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Chargement des messages...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await ChatStorage.init();

      if (mounted) Navigator.pop(context);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagesScreen()),
        );
      }
    } catch (e) {
      print('❌ Erreur lors de l\'ouverture des messages: $e');

      if (mounted) Navigator.pop(context);

      _showSnackbar(
        'Erreur lors du chargement des messages. Veuillez réessayer.',
        isError: true,
      );
    }
  }

  void _onOpenSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  void _onShowPreferences() {
    ProfileDialogs.showPreferencesDialog(
      context,
      userPreferences: userPreferences,
      onSave: () async {
        await _savePreferences();
        if (mounted) setState(() {});
        _showSnackbar('Préférences enregistrées!');
      },
    );
  }

  void _onShowNotifications() {
    final dialogSettings = NotificationSettings(
      reservationNotifications: notificationSettings.reservationNotifications,
      promotionNotifications: notificationSettings.promotionNotifications,
      newsletter: notificationSettings.newsletter,
      messageNotifications: notificationSettings.messageNotifications,
      pushNotifications: notificationSettings.pushNotifications,
      emailNotifications: notificationSettings.emailNotifications,
      smsNotifications: notificationSettings.smsNotifications,
      soundEnabled: notificationSettings.soundEnabled,
      vibrationEnabled: notificationSettings.vibrationEnabled,
      silentHoursEnabled: notificationSettings.silentHoursEnabled,
    );

    ProfileDialogs.showNotificationSettingsDialog(
      context,
      notificationSettings: dialogSettings,
      onSave: () async {
        setState(() {
          notificationSettings.reservationNotifications = dialogSettings.reservationNotifications;
          notificationSettings.promotionNotifications = dialogSettings.promotionNotifications;
          notificationSettings.newsletter = dialogSettings.newsletter;
          notificationSettings.messageNotifications = dialogSettings.messageNotifications;
          notificationSettings.pushNotifications = dialogSettings.pushNotifications;
          notificationSettings.emailNotifications = dialogSettings.emailNotifications;
          notificationSettings.smsNotifications = dialogSettings.smsNotifications;
          notificationSettings.soundEnabled = dialogSettings.soundEnabled;
          notificationSettings.vibrationEnabled = dialogSettings.vibrationEnabled;
          notificationSettings.silentHoursEnabled = dialogSettings.silentHoursEnabled;
        });

        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4CAF50).withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Sauvegarde finale...',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          await _saveNotificationSettings();
          
          if (mounted) Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    '✅ Paramètres enregistrés avec succès!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              backgroundColor: Color(0xFF06D6A0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(16),
            ),
          );
          
        } catch (e) {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          
          print('❌ Erreur lors de la sauvegarde: $e');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    '⚠️ Les modifications ont été appliquées localement',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFFFA726),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(16),
            ),
          );
        }
      },
    );
  }

  void _onShowHelp() {
    ProfileDialogs.showHelpDialog(context);
  }

  void _onShowContact() {
    ProfileDialogs.showContactDialog(context);
  }

  void _onShowTerms() {
    ProfileDialogs.showTermsDialog(context);
  }

  void _onLogout() {
    ProfileDialogs.showLogoutDialog(
      context,
      onConfirmLogout: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (route) => false,
        );
        _showSnackbar('Déconnexion réussie!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEC407A),
                  const Color(0xFFF06292),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC407A).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFEC407A),
                      const Color(0xFFF06292),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.8],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: ProfileHeader(
                    currentUser: currentUser,
                    onEdit: _onEditProfile,
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                PersonalInfoSection(
                  currentUser: currentUser,
                  onEditProfile: _onEditProfile,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEC407A).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QuickActionsSection(
                        onReservations: _onOpenReservations,
                        onNotifications: _onOpenNotifications,
                        onMessages: _onOpenMessages,
                        onSettings: _onOpenSettings,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF8F9FF),
                      ),
                      SettingsSection(
                      onShowPreferences: _onShowPreferences,
                      onShowNotifications: _onShowNotifications,
                    ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF42A5F5).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SupportSection(
                    onHelp: _onShowHelp,
                    onContact: _onShowContact,
                    onTerms: _onShowTerms,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLogoutButton(),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC407A).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onLogout,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEC407A),
                  const Color(0xFFF06292),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}