// lib/services/profile_data_service.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/preferences.dart';
import '../models/security_settings.dart';
import '../models/notification_settings.dart';

class ProfileDataService {
  // Charger toutes les données
  Future<Map<String, dynamic>> loadAllData() async {
    try {
      final userBox = Hive.box<User>('users');
      final prefsBox = Hive.box<Preferences>('preferences');
      final securityBox = Hive.box<SecuritySettings>('security_settings');
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      final devicesBox = Hive.box('connected_devices');

      // User
      User user;
      if (userBox.isNotEmpty) {
        user = userBox.getAt(0)!;
      } else {
        user = _getDefaultUser();
      }

      // Preferences
      Preferences preferences;
      if (prefsBox.isNotEmpty) {
        preferences = prefsBox.getAt(0)!;
      } else {
        preferences = _getDefaultPreferences();
        await prefsBox.add(preferences);
      }

      // Security
      SecuritySettings security;
      if (securityBox.isNotEmpty) {
        security = securityBox.getAt(0)!;
      } else {
        security = _getDefaultSecuritySettings();
        await securityBox.add(security);
      }

      // Notifications
      NotificationSettings notifications;
      if (notifBox.isNotEmpty) {
        notifications = notifBox.getAt(0)!;
      } else {
        notifications = _getDefaultNotificationSettings();
        await notifBox.add(notifications);
      }

      // Devices
      List<Map<String, dynamic>> devices;
      if (devicesBox.isNotEmpty) {
        devices = List<Map<String, dynamic>>.from(devicesBox.get('devices') ?? []);
      } else {
        devices = _getDefaultDevices();
        await devicesBox.put('devices', devices);
      }

      return {
        'user': user,
        'preferences': preferences,
        'security': security,
        'notifications': notifications,
        'devices': devices,
      };
    } catch (e) {
      print('❌ Erreur lors du chargement des données: $e');
      return {
        'user': _getDefaultUser(),
        'preferences': _getDefaultPreferences(),
        'security': _getDefaultSecuritySettings(),
        'notifications': _getDefaultNotificationSettings(),
        'devices': _getDefaultDevices(),
      };
    }
  }

  // Sauvegarder user
  Future<void> saveUser(User user) async {
    try {
      final userBox = Hive.box<User>('users');
      await userBox.put(0, user);
    } catch (e) {
      print('Erreur sauvegarde user: $e');
      rethrow;
    }
  }

  // Sauvegarder préférences
  Future<void> savePreferences(Preferences prefs) async {
    try {
      final prefsBox = Hive.box<Preferences>('preferences');
      await prefsBox.putAt(0, prefs);
    } catch (e) {
      print('Erreur sauvegarde préférences: $e');
      rethrow;
    }
  }

  // Sauvegarder sécurité
  Future<void> saveSecuritySettings(SecuritySettings settings) async {
    try {
      final securityBox = Hive.box<SecuritySettings>('security_settings');
      await securityBox.putAt(0, settings);
    } catch (e) {
      print('Erreur sauvegarde sécurité: $e');
      rethrow;
    }
  }

  // Sauvegarder notifications
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    try {
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      await notifBox.putAt(0, settings);
    } catch (e) {
      print('Erreur sauvegarde notifications: $e');
      rethrow;
    }
  }

  // Sauvegarder appareils
  Future<void> saveDevices(List<Map<String, dynamic>> devices) async {
    try {
      final devicesBox = Hive.box('connected_devices');
      await devicesBox.put('devices', devices);
    } catch (e) {
      print('Erreur sauvegarde appareils: $e');
      rethrow;
    }
  }

  // Valeurs par défaut
  User _getDefaultUser() {
    return User(
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

  Preferences _getDefaultPreferences() {
    return Preferences(
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
  }

  SecuritySettings _getDefaultSecuritySettings() {
    return SecuritySettings(
      twoFactorEnabled: false,
      biometricLogin: false,
      autoLogout: true,
      showActivityStatus: true,
      soundEnabled: true,
      silentHoursEnabled: false,
      silentHoursStart: TimeOfDay(hour: 22, minute: 0),
      silentHoursEnd: TimeOfDay(hour: 8, minute: 0),
    );
  }

  NotificationSettings _getDefaultNotificationSettings() {
    return NotificationSettings(
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

  List<Map<String, dynamic>> _getDefaultDevices() {
    return [
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
  }
}