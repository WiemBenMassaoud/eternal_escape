// lib/utils/profile_dialogs.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/preferences.dart';
import '../models/notification_settings.dart';
import '../screens/welcome_screen.dart';

class ProfileDialogs {
  static Future<void> _saveUserData(User user) async {
    try {
      final userBox = Hive.box<User>('users');
      await userBox.put(0, user);
      print('Utilisateur sauvegardé dans Hive: ${user.nomComplet}');
    } catch (e) {
      print('Erreur sauvegarde utilisateur Hive: $e');
    }
  }

  static Future<void> _savePreferences(Preferences prefs) async {
    try {
      final prefsBox = Hive.box<Preferences>('preferences');
      await prefsBox.put(0, prefs);
      print('Préférences sauvegardées dans Hive');
    } catch (e) {
      print('Erreur sauvegarde préférences Hive: $e');
    }
  }

  static Future<void> _saveNotificationSettings(NotificationSettings notifications) async {
    try {
      print('🔍 Début de la sauvegarde des paramètres de notification...');
      
      if (!Hive.isAdapterRegistered(6)) {
        print('⚠️ Adapter non enregistré, tentative d\'enregistrement...');
        Hive.registerAdapter(NotificationSettingsAdapter());
        await Future.delayed(Duration(milliseconds: 100));
      }
      
      final notifBox = Hive.box<NotificationSettings>('notification_settings');
      print('📦 Box obtenue: ${notifBox.name}, ouverte: ${notifBox.isOpen}');
      
      final settingsToSave = NotificationSettings(
        reservationNotifications: notifications.reservationNotifications,
        promotionNotifications: notifications.promotionNotifications,
        newsletter: notifications.newsletter,
        messageNotifications: notifications.messageNotifications,
        pushNotifications: notifications.pushNotifications,
        emailNotifications: notifications.emailNotifications,
        smsNotifications: notifications.smsNotifications,
        soundEnabled: notifications.soundEnabled,
        vibrationEnabled: notifications.vibrationEnabled,
        silentHoursEnabled: notifications.silentHoursEnabled,
      );
      
      print('💾 Tentative de sauvegarde...');
      await notifBox.put(0, settingsToSave);
      
      final saved = notifBox.get(0);
      if (saved != null) {
        print('✅ SUCCÈS: Paramètres sauvegardés avec succès!');
      } else {
        print('⚠️ ATTENTION: Les paramètres semblent ne pas être sauvegardés');
      }
      
    } catch (e, stack) {
      print('❌ ERREUR lors de la sauvegarde notifications Hive:');
      print('Erreur: $e');
      print('Stack trace: $stack');
      
      try {
        print('🔄 Tentative de sauvegarde alternative...');
        final backupBox = await Hive.openBox('notification_backup');
        await backupBox.put('settings', {
          'timestamp': DateTime.now().toIso8601String(),
          'reservationNotifications': notifications.reservationNotifications,
          'promotionNotifications': notifications.promotionNotifications,
          'newsletter': notifications.newsletter,
          'messageNotifications': notifications.messageNotifications,
          'pushNotifications': notifications.pushNotifications,
          'emailNotifications': notifications.emailNotifications,
          'smsNotifications': notifications.smsNotifications,
          'soundEnabled': notifications.soundEnabled,
          'vibrationEnabled': notifications.vibrationEnabled,
          'silentHoursEnabled': notifications.silentHoursEnabled,
        });
        print('✅ Sauvegardé dans notification_backup');
      } catch (backupError) {
        print('❌ Échec de la sauvegarde alternative: $backupError');
      }
      
      throw Exception('Impossible de sauvegarder les paramètres de notification. Veuillez réessayer.');
    }
  }

  static void showEditProfileDialog(
    BuildContext context, {
    required User currentUser,
    required VoidCallback onSave,
  }) {
    String prenom = currentUser.prenom;
    String nom = currentUser.nom;
    String email = currentUser.email;
    String telephone = currentUser.telephone;
    String adresse = currentUser.adresse;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.edit_rounded, color: Color(0xFF6C63FF), size: 22),
              ),
              SizedBox(width: 12),
              Text(
                'Modifier le profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    ),
                  ),
                  controller: TextEditingController(text: prenom),
                  onChanged: (value) => prenom = value,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    ),
                  ),
                  controller: TextEditingController(text: nom),
                  onChanged: (value) => nom = value,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    ),
                  ),
                  controller: TextEditingController(text: email),
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    ),
                  ),
                  controller: TextEditingController(text: telephone),
                  onChanged: (value) => telephone = value,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    ),
                  ),
                  controller: TextEditingController(text: adresse),
                  onChanged: (value) => adresse = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: TextStyle(color: Color(0xFF666666)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print('Bouton Enregistrer cliqué!');
                currentUser.prenom = prenom;
                currentUser.nom = nom;
                currentUser.email = email;
                currentUser.telephone = telephone;
                currentUser.adresse = adresse;
                print('Nouvelles valeurs: ${currentUser.nomComplet} - ${currentUser.email}');

                try {
                  await _saveUserData(currentUser);
                } catch (e) {
                  print('Erreur Hive: $e');
                }

                Navigator.pop(context);
                
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (onSave != null) {
                    onSave();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Modifications enregistrées!'),
                        ],
                      ),
                      backgroundColor: Color(0xFF06D6A0),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  static void showSnackbar(BuildContext context, String message, {bool isError = false}) {
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

  static void showPreferencesDialog(
    BuildContext context, {
    required Preferences userPreferences,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.settings_rounded, color: Color(0xFFFF9800), size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Préférences',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSwitchPreference(
                            'Services de localisation',
                            Icons.location_on_rounded,
                            'Utiliser ma position pour des recommandations',
                            userPreferences.locationServices,
                            (value) => setState(() {
                              userPreferences.locationServices = value;
                            }),
                          ),
                          _buildSwitchPreference(
                            'Synchronisation automatique',
                            Icons.sync_rounded,
                            'Synchroniser les données en arrière-plan',
                            userPreferences.autoSync,
                            (value) => setState(() {
                              userPreferences.autoSync = value;
                            }),
                          ),
                          ListTile(
                            onTap: () => _showTravelPreferencesDialog(context, userPreferences, setState),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.flight_rounded, color: Color(0xFF6C63FF), size: 20),
                            ),
                            title: Text(
                              'Préférences de voyage',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              'Classe, siège, repas, etc.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                          ListTile(
                            onTap: () => _showContentPreferencesDialog(context, userPreferences, setState),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.travel_explore_rounded, color: Color(0xFF4CAF50), size: 20),
                            ),
                            title: Text(
                              'Préférences de contenu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              'Personnaliser vos recommandations',
                              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Color(0xFFEAEAFF)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            userPreferences.language = 'Français';
                            userPreferences.currency = 'EUR';
                            userPreferences.theme = 'Clair';
                            userPreferences.locationServices = true;
                            userPreferences.autoSync = true;
                            userPreferences.notificationFrequency = 'Immédiate';
                            userPreferences.travelClass = 'Économique';
                            userPreferences.seatPreference = 'Fenêtre';
                            userPreferences.mealPreference = 'Standard';
                            userPreferences.hotelType = '3-4 étoiles';
                            userPreferences.favoriteDestinations = ['Plage', 'Montagne', 'Ville'];
                            userPreferences.averageBudget = '500-1000€';
                            userPreferences.favoriteActivities = ['Randonnée', 'Gastronomie', 'Culture'];
                          });
                          showSnackbar(context, 'Préférences réinitialisées', isError: false);
                        },
                        child: Text(
                          'Réinitialiser',
                          style: TextStyle(color: Color(0xFFFF9800)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await _savePreferences(userPreferences);
                            print('Préférences sauvegardées');
                            
                            if (onSave != null) {
                              onSave();
                            }
                            
                            Navigator.pop(context);
                            
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showSnackbar(context, 'Préférences enregistrées avec succès', isError: false);
                            });
                            
                          } catch (e) {
                            print('Erreur sauvegarde préférences: $e');
                            showSnackbar(context, 'Erreur lors de la sauvegarde', isError: true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Appliquer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildSwitchPreference(String title, IconData icon, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Color(0xFF4CAF50), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF4CAF50),
    );
  }

  static void _showTravelPreferencesDialog(BuildContext context, Preferences userPreferences, StateSetter parentSetState) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.flight_rounded, color: Color(0xFF6C63FF), size: 22),
                ),
                SizedBox(width: 12),
                Text(
                  'Préférences de voyage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Classe de vol'),
                    subtitle: Text(userPreferences.travelClass),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _showTravelClassSelector(context, userPreferences, setState),
                  ),
                  ListTile(
                    title: Text('Siège préféré'),
                    subtitle: Text(userPreferences.seatPreference),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _showSeatPreferenceSelector(context, userPreferences, setState),
                  ),
                  ListTile(
                    title: Text('Repas spéciaux'),
                    subtitle: Text(userPreferences.mealPreference),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _showMealPreferenceSelector(context, userPreferences, setState),
                  ),
                  ListTile(
                    title: Text('Type d\'hôtel'),
                    subtitle: Text(userPreferences.hotelType),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _showHotelTypeSelector(context, userPreferences, setState),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Annuler',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  parentSetState(() {});
                  Navigator.pop(context);
                  showSnackbar(context, 'Préférences de voyage enregistrées', isError: false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showTravelClassSelector(BuildContext context, Preferences userPreferences, StateSetter setState) {
    List<String> classes = ['Économique', 'Premium', 'Affaires', 'Première'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Text('Classe de vol'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: classes.map((cls) {
            return RadioListTile<String>(
              title: Text(cls),
              value: cls,
              groupValue: userPreferences.travelClass,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    userPreferences.travelClass = value;
                  });
                  Navigator.pop(context);
                }
              },
              activeColor: Color(0xFF6C63FF),
            );
          }).toList(),
        ),
      ),
    );
  }

  static void _showSeatPreferenceSelector(BuildContext context, Preferences userPreferences, StateSetter setState) {
    List<String> seats = ['Fenêtre', 'Couloir', 'Aile'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Text('Siège préféré'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: seats.map((seat) {
            return RadioListTile<String>(
              title: Text(seat),
              value: seat,
              groupValue: userPreferences.seatPreference,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    userPreferences.seatPreference = value;
                  });
                  Navigator.pop(context);
                }
              },
              activeColor: Color(0xFF6C63FF),
            );
          }).toList(),
        ),
      ),
    );
  }

  static void _showMealPreferenceSelector(BuildContext context, Preferences userPreferences, StateSetter setState) {
    List<String> meals = ['Standard', 'Végétarien', 'Halal', 'Kasher', 'Sans gluten'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Text('Repas spéciaux'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: meals.map((meal) {
            return RadioListTile<String>(
              title: Text(meal),
              value: meal,
              groupValue: userPreferences.mealPreference,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    userPreferences.mealPreference = value;
                  });
                  Navigator.pop(context);
                }
              },
              activeColor: Color(0xFF6C63FF),
            );
          }).toList(),
        ),
      ),
    );
  }

  static void _showHotelTypeSelector(BuildContext context, Preferences userPreferences, StateSetter setState) {
    List<String> hotels = ['1-2 étoiles', '3-4 étoiles', '5 étoiles', 'Luxe'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Text('Type d\'hôtel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: hotels.map((hotel) {
            return RadioListTile<String>(
              title: Text(hotel),
              value: hotel,
              groupValue: userPreferences.hotelType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    userPreferences.hotelType = value;
                  });
                  Navigator.pop(context);
                }
              },
              activeColor: Color(0xFF6C63FF),
            );
          }).toList(),
        ),
      ),
    );
  }

  static void _showContentPreferencesDialog(BuildContext context, Preferences userPreferences, StateSetter parentSetState) {
    TextEditingController destinationsController = TextEditingController(text: userPreferences.favoriteDestinations.join(', '));
    TextEditingController budgetController = TextEditingController(text: userPreferences.averageBudget);
    TextEditingController activitiesController = TextEditingController(text: userPreferences.favoriteActivities.join(', '));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.travel_explore_rounded, color: Color(0xFF4CAF50), size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Préférences de contenu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: destinationsController,
                            decoration: InputDecoration(
                              labelText: 'Destinations préférées',
                              hintText: 'Séparées par des virgules',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF4CAF50)),
                              ),
                              prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF4CAF50)),
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: budgetController,
                            decoration: InputDecoration(
                              labelText: 'Budget moyen',
                              hintText: 'Ex: 500-1000€',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF4CAF50)),
                              ),
                              prefixIcon: Icon(Icons.euro_rounded, color: Color(0xFF4CAF50)),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: activitiesController,
                            decoration: InputDecoration(
                              labelText: 'Activités préférées',
                              hintText: 'Séparées par des virgules',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF4CAF50)),
                              ),
                              prefixIcon: Icon(Icons.directions_run_rounded, color: Color(0xFF4CAF50)),
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ces préférences seront utilisées pour personnaliser vos recommandations de voyage.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: Color(0xFF666666)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            userPreferences.favoriteDestinations =
                                destinationsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                            userPreferences.averageBudget = budgetController.text;
                            userPreferences.favoriteActivities =
                                activitiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                          });
                          parentSetState(() {});
                          Navigator.pop(context);
                          showSnackbar(context, 'Préférences de contenu enregistrées', isError: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Enregistrer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void showNotificationSettingsDialog(
    BuildContext context, {
    required NotificationSettings notificationSettings,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.notifications_active_rounded, color: Color(0xFF4CAF50), size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSectionTitle('Types de notifications'),
                          _buildNotificationOption(
                            'Réservations',
                            Icons.confirmation_number_rounded,
                            'Statut des réservations et rappels',
                            notificationSettings.reservationNotifications,
                            (value) => setState(() {
                              notificationSettings.reservationNotifications = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Promotions',
                            Icons.local_offer_rounded,
                            'Offres spéciales et réductions',
                            notificationSettings.promotionNotifications,
                            (value) => setState(() {
                              notificationSettings.promotionNotifications = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Newsletter',
                            Icons.newspaper_rounded,
                            'Nouvelles destinations et conseils',
                            notificationSettings.newsletter,
                            (value) => setState(() {
                              notificationSettings.newsletter = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Messages',
                            Icons.chat_rounded,
                            'Messages et mises à jour de compte',
                            notificationSettings.messageNotifications,
                            (value) => setState(() {
                              notificationSettings.messageNotifications = value;
                            }),
                          ),
                          _buildSectionTitle('Canaux de notification'),
                          _buildNotificationOption(
                            'Notifications push',
                            Icons.notifications_rounded,
                            'Recevoir des notifications push',
                            notificationSettings.pushNotifications,
                            (value) => setState(() {
                              notificationSettings.pushNotifications = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Notifications email',
                            Icons.email_rounded,
                            'Recevoir des emails',
                            notificationSettings.emailNotifications,
                            (value) => setState(() {
                              notificationSettings.emailNotifications = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Notifications SMS',
                            Icons.sms_rounded,
                            'Recevoir des SMS',
                            notificationSettings.smsNotifications,
                            (value) => setState(() {
                              notificationSettings.smsNotifications = value;
                            }),
                          ),
                          _buildSectionTitle('Personnalisation'),
                          _buildNotificationOption(
                            'Son des notifications',
                            Icons.volume_up_rounded,
                            'Activer le son des notifications',
                            notificationSettings.soundEnabled,
                            (value) => setState(() {
                              notificationSettings.soundEnabled = value;
                            }),
                          ),
                          _buildNotificationOption(
                            'Vibrations',
                            Icons.vibration_rounded,
                            'Activer les vibrations',
                            notificationSettings.vibrationEnabled,
                            (value) => setState(() {
                              notificationSettings.vibrationEnabled = value;
                            }),
                          ),
                          SwitchListTile(
                            secondary: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.schedule_rounded, color: Color(0xFF6C63FF), size: 20),
                            ),
                            title: Text(
                              'Plage horaire silencieuse',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              'Ne pas déranger de 22:00 à 08:00',
                              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                            value: notificationSettings.silentHoursEnabled,
                            onChanged: (value) {
                              setState(() {
                                notificationSettings.silentHoursEnabled = value;
                              });
                            },
                            activeColor: Color(0xFF6C63FF),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Color(0xFFEAEAFF)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B6B),
                          side: BorderSide(color: Color(0xFFEAEAFF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Tout désactiver'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
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
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: Color(0xFF4CAF50)),
                                      SizedBox(height: 16),
                                      Text('Sauvegarde en cours...'),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            await _saveNotificationSettings(notificationSettings);
                            
                            Navigator.pop(context);
                            
                            print('✅ Paramètres de notification sauvegardés');
                            
                            Navigator.pop(context);
                            
                            if (onSave != null) {
                              await Future.delayed(Duration(milliseconds: 300));
                              onSave();
                            }
                            
                          } catch (e) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            
                            print('❌ Erreur sauvegarde notifications: $e');
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.white, size: 24),
                                    SizedBox(width: 12),
                                    Text('Erreur lors de la sauvegarde. Réessayez.'),
                                  ],
                                ),
                                backgroundColor: Color(0xFFFF6B6B),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Enregistrer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildNotificationOption(String title, IconData icon, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Color(0xFF4CAF50), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF4CAF50),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  static void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.help_rounded, color: Color(0xFF6C63FF), size: 22),
            ),
            SizedBox(width: 12),
            Text(
              'Centre d\'aide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.chat_rounded, color: Color(0xFF6C63FF)),
              ),
              title: Text('Chat en direct'),
              subtitle: Text('Support 24/7'),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.call_rounded, color: Color(0xFF6C63FF)),
              ),
              title: Text('Appeler'),
              subtitle: Text('+216 70 123 456'),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.email_rounded, color: Color(0xFF6C63FF)),
              ),
              title: Text('Email'),
              subtitle: Text('support@eternalescape.com'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }

  static void showContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    final subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF36D1DC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.contact_support_rounded, color: Color(0xFF36D1DC), size: 22),
            ),
            SizedBox(width: 12),
            Text(
              'Contactez-nous',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text(
                'Remplissez ce formulaire pour nous contacter',
                style: TextStyle(
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF6C63FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF6C63FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Sujet',
                  prefixIcon: Icon(Icons.subject_rounded, color: Color(0xFF6C63FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF666666)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nous répondons généralement dans les 24 heures',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.isEmpty || subjectController.text.isEmpty) {
                showSnackbar(context, 'Veuillez remplir tous les champs', isError: true);
                return;
              }

              Navigator.pop(context);
              showSnackbar(context, 'Message envoyé avec succès !', isError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF36D1DC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Envoyer le message'),
          ),
        ],
      ),
    );
  }

  static void showTermsDialog(BuildContext context) {
    bool termsAccepted = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF6C63FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.description_rounded, color: Color(0xFF6C63FF), size: 24),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Conditions d\'utilisation',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTermsSection(
                            '1. Acceptation des conditions',
                            'En utilisant Eternal Escape, vous acceptez les présentes conditions d\'utilisation.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '2. Compte utilisateur',
                            'Vous êtes responsable de la confidentialité de votre compte et de votre mot de passe.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '3. Réservations',
                            'Les réservations sont soumises à disponibilité et aux conditions générales des prestataires.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '4. Paiements',
                            'Les paiements sont sécurisés et non remboursables sauf conditions particulières.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '5. Confidentialité',
                            'Vos données personnelles sont protégées conformément à notre politique de confidentialité.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '6. Annulations',
                            'Les annulations sont soumises aux conditions tarifaires de chaque réservation.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '7. Responsabilité',
                            'Eternal Escape agit comme intermédiaire et n\'est pas responsable des services fournis.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '8. Modifications',
                            'Nous nous réservons le droit de modifier ces conditions à tout moment.',
                          ),
                          SizedBox(height: 16),
                          _buildTermsSection(
                            '9. Contact',
                            'Pour toute question: support@eternalescape.com',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(color: Color(0xFFEAEAFF)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            termsAccepted = value ?? false;
                          });
                        },
                        activeColor: Color(0xFF6C63FF),
                      ),
                      Expanded(
                        child: Text(
                          'J\'ai lu et j\'accepte les conditions d\'utilisation',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF666666),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text('Annuler'),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: termsAccepted
                            ? () {
                                Navigator.pop(context);
                                showSnackbar(context, 'Conditions acceptées avec succès', isError: false);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Color(0xFFCCCCCC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text('Accepter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  static void showLogoutDialog(
    BuildContext context, {
    required VoidCallback onConfirmLogout,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF6B6B),
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Se déconnecter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFEAEAFF),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vous devrez vous reconnecter la prochaine fois',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF666666),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final scaffoldContext = context;
              
              showDialog(
                context: scaffoldContext,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFFFF6B6B),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Déconnexion en cours...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              
              try {
                await Future.delayed(Duration(milliseconds: 800));
                
                Navigator.pop(scaffoldContext);
                
                onConfirmLogout();
                
              } catch (e) {
                if (scaffoldContext.mounted) {
                  Navigator.pop(scaffoldContext);
                  onConfirmLogout();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: Text(
              'Déconnexion',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}