// lib/screens/profile_screen.dart
// NOTE: Ce fichier contient la logique (chargement Hive, sauvegardes, dialogs, flows)
// et assemble les widgets extraits.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';
import '../../models/preferences.dart';
import '../../models/security_settings.dart';
import '../../models/notification_settings.dart';
import '../screens/messages_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/reservations_screen.dart';
import '../screens/welcome_screen.dart';

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
  late SecuritySettings securitySettings;
  late NotificationSettings notificationSettings;
  List<Map<String, dynamic>> connectedDevices = [];
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
      final securityBox = Hive.box<SecuritySettings>('security_settings');
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      final devicesBox = Hive.box('connected_devices');

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

      if (securityBox.isNotEmpty) {
        securitySettings = securityBox.getAt(0)!;
      } else {
        securitySettings = SecuritySettings(
          twoFactorEnabled: false,
          biometricLogin: false,
          autoLogout: true,
          showActivityStatus: true,
          soundEnabled: true,
          silentHoursEnabled: false,
          silentHoursStart: TimeOfDay(hour: 22, minute: 0),
          silentHoursEnd: TimeOfDay(hour: 8, minute: 0),
        );
        await securityBox.add(securitySettings);
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

      if (devicesBox.isNotEmpty) {
        connectedDevices = List<Map<String, dynamic>>.from(devicesBox.get('devices') ?? []);
      } else {
        connectedDevices = [
          {
            'name': 'iPhone 13 Pro',
            'type': 'mobile',
            'lastActive': DateTime.now().millisecondsSinceEpoch,
            'location': 'Tunis, TN',
            'isActive': true,
            'deviceId': 'iphone-123',
          },
          {
            'name': 'MacBook Pro',
            'type': 'laptop',
            'lastActive': DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch,
            'location': 'Paris, FR',
            'isActive': false,
            'deviceId': 'macbook-456',
          },
        ];
        await devicesBox.put('devices', connectedDevices);
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

      securitySettings = SecuritySettings(
        twoFactorEnabled: false,
        biometricLogin: false,
        autoLogout: true,
        showActivityStatus: true,
        soundEnabled: true,
        silentHoursEnabled: false,
        silentHoursStart: TimeOfDay(hour: 22, minute: 0),
        silentHoursEnd: TimeOfDay(hour: 8, minute: 0),
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

      connectedDevices = [
        {
          'name': 'iPhone 13 Pro',
          'type': 'mobile',
          'lastActive': DateTime.now().millisecondsSinceEpoch,
          'location': 'Tunis, TN',
          'isActive': true,
          'deviceId': 'iphone-123',
        },
      ];
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveDevices() async {
    try {
      final devicesBox = Hive.box('connected_devices');
      await devicesBox.put('devices', connectedDevices);
    } catch (e) {
      print('Erreur sauvegarde appareils: $e');
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      await notifBox.putAt(0, notificationSettings);
    } catch (e) {
      print('Erreur sauvegarde notifications: $e');
      rethrow;
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefsBox = Hive.box<Preferences>('preferences');
      await prefsBox.putAt(0, userPreferences);
    } catch (e) {
      print('Erreur sauvegarde préférences: $e');
      rethrow;
    }
  }

  Future<void> _saveSecuritySettings() async {
    try {
      final securityBox = Hive.box<SecuritySettings>('security_settings');
      await securityBox.putAt(0, securitySettings);
    } catch (e) {
      print('Erreur sauvegarde sécurité: $e');
      rethrow;
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Color(0xFFFF6B6B) : Color(0xFF06D6A0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: isError ? 4 : 2),
        margin: EdgeInsets.all(16),
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
      },
    );
  }

  void _onOpenReservations() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsScreen()));
  }

  void _onOpenNotifications() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
  }

  void _onOpenMessages() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesScreen()));
  }

  void _onOpenSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void _onShowSecurityPrivacy() {
    ProfileDialogs.showSecurityPrivacyDialog(
      context,
      securitySettings: securitySettings,
      connectedDevices: connectedDevices,
      onSave: () async {
        await _saveSecuritySettings();
        await _saveDevices();
        if (mounted) setState(() {});
        _showSnackbar('Paramètres de sécurité enregistrés!');
      },
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
    ProfileDialogs.showNotificationSettingsDialog(
      context,
      notificationSettings: notificationSettings,
      onSave: () async {
        await _saveNotificationSettings();
        if (mounted) setState(() {});
        _showSnackbar('Paramètres de notification enregistrés!');
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
    ProfileDialogs.showLogoutDialog(context, onConfirmLogout: () {  });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Color(0xFF6C63FF),
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileHeader(
                currentUser: currentUser,
                onEdit: _onEditProfile,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              PersonalInfoSection(
                currentUser: currentUser,
                onEditProfile: _onEditProfile,
              ),
              QuickActionsSection(
                onReservations: _onOpenReservations,
                onNotifications: _onOpenNotifications,
                onMessages: _onOpenMessages,
                onSettings: _onOpenSettings,
              ),
              SettingsSection(
                onShowSecurity: _onShowSecurityPrivacy,
                onShowPreferences: _onShowPreferences,
                onShowNotifications: _onShowNotifications,
              ),
              SupportSection(
                onHelp: _onShowHelp,
                onContact: _onShowContact,
                onTerms: _onShowTerms,
              ),
              _buildLogoutButton(),
              SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF6B6B),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Se déconnecter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}