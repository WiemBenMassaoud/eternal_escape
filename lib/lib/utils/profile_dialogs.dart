// lib/utils/profile_dialogs.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/preferences.dart';
import '../models/security_settings.dart';
import '../models/notification_settings.dart';
import '../screens/welcome_screen.dart';

class ProfileDialogs {
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
          title: Text('Modifier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: prenom),
                  onChanged: (value) => prenom = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: nom),
                  onChanged: (value) => nom = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: email),
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: telephone),
                  onChanged: (value) => telephone = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
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
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Bouton Enregistrer cliqué!');
                currentUser.prenom = prenom;
                currentUser.nom = nom;
                currentUser.email = email;
                currentUser.telephone = telephone;
                currentUser.adresse = adresse;
                print('Nouvelles valeurs: ${currentUser.nomComplet} - ${currentUser.email}');

                try {
                  final userBox = Hive.box<User>('users');
                  print('Boîte Hive accessible');
                  userBox.put(0, currentUser);
                  print('Sauvegarde Hive réussie');
                } catch (e) {
                  print('Erreur Hive: $e');
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (onSave != null) {
                    onSave();
                  }
                });

                Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Modifications enregistrées!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              },
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

  static void showSecurityPrivacyDialog(
    BuildContext context, {
    required SecuritySettings securitySettings,
    required List<Map<String, dynamic>> connectedDevices,
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
                          color: Color(0xFF6C63FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.security_rounded, color: Color(0xFF6C63FF), size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Sécurité & Confidentialité',
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
                          _buildSectionTitle('Authentification'),
                          _buildSecurityOption(
                            'Authentification à deux facteurs',
                            'Renforcez la sécurité de votre compte',
                            securitySettings.twoFactorEnabled,
                            (value) {
                              setState(() {
                                securitySettings.twoFactorEnabled = value;
                              });
                              if (value) {
                                _showTwoFactorSetupDialog(context);
                              }
                            },
                          ),
                          _buildSecurityOption(
                            'Connexion biométrique',
                            'Utilisez votre empreinte ou visage',
                            securitySettings.biometricLogin,
                            (value) {
                              setState(() {
                                securitySettings.biometricLogin = value;
                              });
                              if (value) {
                                _showBiometricSetupDialog(context);
                              }
                            },
                          ),
                          _buildSectionTitle('Sécurité'),
                          _buildSecurityOption(
                            'Déconnexion automatique',
                            'Se déconnecter après 15 min d\'inactivité',
                            securitySettings.autoLogout,
                            (value) => setState(() {
                              securitySettings.autoLogout = value;
                            }),
                          ),
                          ListTile(
                            onTap: () => _showChangePasswordDialog(context),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.lock_rounded, color: Color(0xFF6C63FF), size: 20),
                            ),
                            title: Text(
                              'Changer le mot de passe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              'Mettez à jour votre mot de passe régulièrement',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                          _buildSectionTitle('Confidentialité'),
                          _buildSecurityOption(
                            'Afficher le statut en ligne',
                            'Autoriser les autres à voir quand vous êtes connecté',
                            securitySettings.showActivityStatus,
                            (value) => setState(() {
                              securitySettings.showActivityStatus = value;
                            }),
                          ),
                          ListTile(
                            onTap: () => _showPrivacyPolicyDialog(context),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF36D1DC).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.privacy_tip_rounded, color: Color(0xFF36D1DC), size: 20),
                            ),
                            title: Text(
                              'Politique de confidentialité',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                          ListTile(
                            onTap: () => _showDataManagementDialog(context),
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B6B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.delete_outline_rounded, color: Color(0xFFFF6B6B), size: 20),
                            ),
                            title: Text(
                              'Gérer mes données',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              'Télécharger ou supprimer vos données',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 16),
                          _buildCurrentSessionInfo(context, connectedDevices),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => _showAllDevicesDialog(context, connectedDevices),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF666666),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Appareils connectés'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onSave();
                          Navigator.pop(context);
                          showSnackbar(context, 'Paramètres de sécurité mis à jour avec succès', isError: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C63FF),
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

  static Widget _buildSecurityOption(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
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
      activeColor: Color(0xFF6C63FF),
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

  static Widget _buildCurrentSessionInfo(BuildContext dialogContext, List<Map<String, dynamic>> connectedDevices) {
  DateTime now = DateTime.now();
  String formattedTime = '${now.hour}h${now.minute}';

  String deviceInfo = 'Aucun appareil • Connecté depuis $formattedTime';
  
  if (connectedDevices.isNotEmpty) {
    try {
      Map<String, dynamic> activeDevice;
      try {
        activeDevice = connectedDevices.firstWhere((d) => d['isActive'] == true);
      } catch (e) {
        activeDevice = connectedDevices[0];
      }
      
      String deviceName = activeDevice['name']?.toString() ?? 'Appareil inconnu';
      deviceInfo = '$deviceName • Connecté depuis $formattedTime';
    } catch (e) {
      deviceInfo = 'Appareil inconnu • Connecté depuis $formattedTime';
    }
  }

  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Color(0xFFF8F9FF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFEAEAFF)),
    ),
    child: Row(
      children: [
        Icon(Icons.phone_iphone_rounded, color: Color(0xFF6C63FF)),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Session actuelle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                deviceInfo,  // <-- CORRIGÉ ICI
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            _showTerminateAllSessionsDialog(dialogContext, connectedDevices);
          },
          child: Text(
            'Tout fermer',
            style: TextStyle(
              color: Color(0xFFFF6B6B),
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
  static void _showTwoFactorSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configurer l\'authentification à deux facteurs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Scannez le QR code avec votre application d\'authentification:'),
            SizedBox(height: 16),
            Container(
              height: 200,
              width: 200,
              color: Colors.grey[200],
              child: Center(child: Text('QR Code Placeholder')),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Code de vérification',
                border: OutlineInputBorder(),
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
              showSnackbar(context, '2FA activé avec succès', isError: false);
            },
            child: Text('Vérifier'),
          ),
        ],
      ),
    );
  }

  static void _showBiometricSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connexion biométrique'),
        content: Text('Voulez-vous utiliser l\'empreinte digitale ou la reconnaissance faciale pour vous connecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Plus tard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showSnackbar(context, 'Configuration biométrique démarrée', isError: false);
            },
            child: Text('Configurer'),
          ),
        ],
      ),
    );
  }

  static void _showAllDevicesDialog(BuildContext context, List<Map<String, dynamic>> connectedDevices) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Appareils connectés'),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...connectedDevices.map((device) => ListTile(
                        leading: Icon(
                          device['type'] == 'mobile' ? Icons.phone_iphone_rounded : Icons.laptop_rounded,
                          color: Color(0xFF6C63FF),
                        ),
                        title: Text(device['name']),
                        subtitle: Text(
                          '${_formatLastActive(device['lastActive'])} • ${device['location']}',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: device['isActive'] == true
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Actif',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                                onPressed: () => _logoutDevice(context, device['deviceId'], connectedDevices, setState),
                              ),
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _formatLastActive(int timestamp) {
    final lastActive = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) return 'Maintenant';
    if (difference.inHours < 1) return 'Il y a ${difference.inMinutes} min';
    if (difference.inDays < 1) return 'Il y a ${difference.inHours} h';
    if (difference.inDays < 7) return 'Il y a ${difference.inDays} jours';
    return 'Il y a ${(difference.inDays / 7).floor()} semaines';
  }

  static void _logoutDevice(BuildContext context, String deviceId, 
      List<Map<String, dynamic>> connectedDevices, StateSetter setState) {
    setState(() {
      connectedDevices.removeWhere((device) => device['deviceId'] == deviceId);
    });
    showSnackbar(context, 'Appareil déconnecté avec succès', isError: false);
  }

  static void _showTerminateAllSessionsDialog(BuildContext context, List<Map<String, dynamic>> connectedDevices) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terminer toutes les sessions'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter de tous les appareils ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              connectedDevices.clear();
              showSnackbar(context, 'Toutes les sessions ont été terminées', isError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B6B),
            ),
            child: Text('Terminer'),
          ),
        ],
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
                              style: TextStyle(fontSize: 12),
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
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
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
                        onPressed: () {
                          onSave();
                          Navigator.pop(context);
                          showSnackbar(context, 'Préférences enregistrées avec succès', isError: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C63FF),
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
            title: Text('Préférences de voyage'),
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
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  parentSetState(() {});
                  Navigator.pop(context);
                  showSnackbar(context, 'Préférences de voyage enregistrées', isError: false);
                },
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
                              prefixIcon: Icon(Icons.location_on_rounded),
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
                              prefixIcon: Icon(Icons.euro_rounded),
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
                              prefixIcon: Icon(Icons.directions_run_rounded),
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
                        child: Text('Annuler'),
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
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            notificationSettings.reservationNotifications = false;
                            notificationSettings.promotionNotifications = false;
                            notificationSettings.newsletter = false;
                            notificationSettings.messageNotifications = false;
                            notificationSettings.pushNotifications = false;
                            notificationSettings.emailNotifications = false;
                            notificationSettings.smsNotifications = false;
                            notificationSettings.soundEnabled = false;
                            notificationSettings.vibrationEnabled = false;
                            notificationSettings.silentHoursEnabled = false;
                          });
                          showSnackbar(context, 'Toutes les notifications ont été désactivées', isError: false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Tout désactiver'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onSave();
                          Navigator.pop(context);
                          showSnackbar(context, 'Paramètres de notifications mis à jour avec succès', isError: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
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

  static void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                border: OutlineInputBorder(),
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
              showSnackbar(context, 'Mot de passe changé avec succès', isError: false);
            },
            child: Text('Changer'),
          ),
        ],
      ),
    );
  }

  static void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                    child: Icon(Icons.privacy_tip_rounded, color: Color(0xFF6C63FF), size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Politique de confidentialité',
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
                      Text(
                        'Comment nous utilisons vos données',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nous respectons votre vie privée et nous nous engageons à protéger vos données personnelles. '
                        'Cette politique explique comment nous collectons, utilisons et protégeons vos informations.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildPrivacySection(
                        'Données collectées',
                        '• Informations de profil\n• Historique de réservations\n• Préférences de voyage\n• Données d\'utilisation',
                      ),
                      SizedBox(height: 16),
                      _buildPrivacySection(
                        'Utilisation des données',
                        '• Personnaliser votre expérience\n• Améliorer nos services\n• Envoyer des notifications pertinentes\n• Sécuriser votre compte',
                      ),
                      SizedBox(height: 16),
                      _buildPrivacySection(
                        'Partage des données',
                        'Nous ne vendons jamais vos données. Nous pouvons les partager uniquement avec :\n• Nos partenaires de voyage\n• Les autorités si requis par la loi\n• Les services de paiement',
                      ),
                      SizedBox(height: 16),
                      _buildPrivacySection(
                        'Vos droits',
                        '• Accéder à vos données\n• Corriger les erreurs\n• Supprimer votre compte\n• Exporter vos données\n• Désactiver le suivi',
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Dernière mise à jour: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('J\'ai compris'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildPrivacySection(String title, String content) {
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

  static void _showDataManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Gérer mes données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.download_rounded, color: Color(0xFF36D1DC)),
              title: Text('Exporter mes données'),
              subtitle: Text('Télécharger toutes mes données personnelles'),
              onTap: () {
                Navigator.pop(context);
                _exportUserData(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: Color(0xFFFF6B6B)),
              title: Text('Supprimer mon compte'),
              subtitle: Text('Cette action est irréversible'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  static Future<void> _exportUserData(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Exportation des données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF36D1DC)),
            SizedBox(height: 16),
            Text('Préparation de vos données...'),
          ],
        ),
      ),
    );

    try {
      await Future.delayed(Duration(seconds: 1));

      final Map<String, dynamic> exportData = {
        'exportDate': DateTime.now().toIso8601String(),
      };

      final jsonString = jsonEncode(exportData);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exportation terminée'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF36D1DC), size: 48),
              SizedBox(height: 16),
              Text(
                'Vos données ont été préparées avec succès.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Taille: ${(jsonString.length / 1024).toStringAsFixed(2)} KB',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showSnackbar(context, 'Erreur lors de l\'exportation: $e', isError: true);
    }
  }

  static void _showDeleteAccountDialog(BuildContext context) {
    TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer mon compte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cette action supprimera définitivement :'),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_remove_rounded, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text('Votre profil'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.settings_rounded, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text('Vos préférences'),
              ],
            ),
            SizedBox(height: 16),
            Text('Tapez "SUPPRIMER" pour confirmer :'),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
              if (confirmController.text == 'SUPPRIMER') {
                Navigator.pop(context);
                // La suppression réelle sera gérée par l'appelant
                showSnackbar(context, 'Compte supprimé avec succès', isError: false);
              } else {
                showSnackbar(context, 'Veuillez taper "SUPPRIMER" pour confirmer', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B6B),
            ),
            child: Text('Supprimer définitivement'),
          ),
        ],
      ),
    );
  }

  static void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Centre d\'aide'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.chat_rounded),
              title: Text('Chat en direct'),
              subtitle: Text('Support 24/7'),
            ),
            ListTile(
              leading: Icon(Icons.call_rounded),
              title: Text('Appeler'),
              subtitle: Text('+216 70 123 456'),
            ),
            ListTile(
              leading: Icon(Icons.email_rounded),
              title: Text('Email'),
              subtitle: Text('support@voyage.com'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
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
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Sujet',
                  prefixIcon: Icon(Icons.subject_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
                  Divider(),
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
            // Fermer le dialogue de confirmation
            Navigator.pop(context);
            
            // Récupérer le contexte de la page principale avant d'afficher le loading
            final scaffoldContext = context;
            
            // Afficher un indicateur de chargement
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
                        color: Color(0xFF6C63FF),
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
              // Attendre un moment pour l'animation
              await Future.delayed(Duration(milliseconds: 800));
              
              // Fermer le dialogue de chargement
              Navigator.pop(scaffoldContext);
              
              // Appeler la callback qui va nettoyer Hive ET naviguer
              onConfirmLogout();
              
            } catch (e) {
              // En cas d'erreur, fermer le loading et naviguer quand même
              if (scaffoldContext.mounted) {
                Navigator.pop(scaffoldContext);
                onConfirmLogout();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B6B),
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
}}