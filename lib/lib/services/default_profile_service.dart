import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/preferences.dart';
import '../models/security_settings.dart';
import '../models/notification_settings.dart';

class DefaultProfileService {
  DefaultProfileService._();

  /// Crée un utilisateur par défaut s'il n'existe pas déjà.
  static Future<void> createDefaultUserIfNeeded() async {
    try {
      if (!Hive.isBoxOpen('users')) {
        await Hive.openBox<User>('users');
      }
      final userBox = Hive.box<User>('users');
      if (userBox.isEmpty) {
        final defaultUser = User(
          email: 'benaliamal@eternalescape.com',
          prenom: 'amal',
          nom: 'Eternal Escape',
          telephone: '+216 29 520 140',
          adresse: 'Sfax, Tunis',
        );
        await userBox.add(defaultUser);
      }
    } catch (e) {
      // Propager l'erreur vers l'appelant si besoin
      rethrow;
    }
  }

  /// Sauvegarde l'ensemble des paramètres par défaut dans Hive (preferences, security, notifications, devices).
  static Future<void> saveDefaultSettings() async {
    try {
      // Preferences
      if (!Hive.isBoxOpen('preferences')) {
        await Hive.openBox<Preferences>('preferences');
      }
      final prefsBox = Hive.box<Preferences>('preferences');
      if (prefsBox.isEmpty) {
        final defaultPrefs = Preferences(
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
        await prefsBox.add(defaultPrefs);
      }

      // Security settings
      if (!Hive.isBoxOpen('security_settings')) {
        await Hive.openBox<SecuritySettings>('security_settings');
      }
      final securityBox = Hive.box<SecuritySettings>('security_settings');
      if (securityBox.isEmpty) {
        final defaultSecurity = SecuritySettings(
          twoFactorEnabled: false,
          biometricLogin: false,
          autoLogout: true,
          showActivityStatus: true,
          soundEnabled: true,
          silentHoursEnabled: false,
          silentHoursStart: const TimeOfDay(hour: 22, minute: 0),
          silentHoursEnd: const TimeOfDay(hour: 8, minute: 0),
        );
        await securityBox.add(defaultSecurity);
      }

      // Notification settings
      if (!Hive.isBoxOpen('notification_settings')) {
        await Hive.openBox<NotificationSettings>('notification_settings');
      }
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      if (notifBox.isEmpty) {
        final defaultNotif = NotificationSettings(
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
        await notifBox.add(defaultNotif);
      }

      // Connected devices (simple map box)
      if (!Hive.isBoxOpen('connected_devices')) {
        await Hive.openBox('connected_devices');
      }
      final devicesBox = Hive.box('connected_devices');
      if (!devicesBox.containsKey('devices')) {
        final defaultDevices = [
          {
            'name': 'iPhone 13 Pro',
            'type': 'mobile',
            'lastActive': DateTime.now().millisecondsSinceEpoch,
            'location': 'Paris, FR',
            'isActive': true,
            'deviceId': 'iphone-123',
          },
        ];
        await devicesBox.put('devices', defaultDevices);
      }
    } catch (e) {
      // Rethrow pour que l'appelant puisse gérer l'erreur si nécessaire
      rethrow;
    }
  }
}