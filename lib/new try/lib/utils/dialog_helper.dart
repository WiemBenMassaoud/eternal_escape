// lib/utils/dialog_helper.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/preferences.dart';
import '../models/security_settings.dart';
import '../models/notification_settings.dart';
import 'dialog_widgets.dart'; // Import des widgets complexes

class DialogHelper {
  // ===== EDIT PROFILE DIALOG =====
  static void showEditProfileDialog(
    BuildContext context,
    User currentUser, {
    required Function(User) onSave,
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
          title: Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Prénom', border: OutlineInputBorder()),
                  controller: TextEditingController(text: prenom),
                  onChanged: (value) => prenom = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                  controller: TextEditingController(text: nom),
                  onChanged: (value) => nom = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  controller: TextEditingController(text: email),
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                  controller: TextEditingController(text: telephone),
                  onChanged: (value) => telephone = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Adresse', border: OutlineInputBorder()),
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
                currentUser.prenom = prenom;
                currentUser.nom = nom;
                currentUser.email = email;
                currentUser.telephone = telephone;
                currentUser.adresse = adresse;
                Navigator.pop(context);
                onSave(currentUser);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // ===== SECURITY & PRIVACY DIALOG =====
  static void showSecurityPrivacyDialog(
    BuildContext context,
    SecuritySettings settings,
    List<Map<String, dynamic>> devices, {
    required Function(SecuritySettings) onSecurityChanged,
    required Function(List<Map<String, dynamic>>) onDevicesChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => SecurityPrivacyDialogWidget(
        settings: settings,
        devices: devices,
        onSecurityChanged: onSecurityChanged,
        onDevicesChanged: onDevicesChanged,
      ),
    );
  }

  // ===== PREFERENCES DIALOG =====
  static void showPreferencesDialog(
    BuildContext context,
    Preferences preferences, {
    required Function(Preferences) onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => PreferencesDialogWidget(
        preferences: preferences,
        onSave: onSave,
      ),
    );
  }

  // ===== NOTIFICATION SETTINGS DIALOG =====
  static void showNotificationSettingsDialog(
    BuildContext context,
    NotificationSettings settings, {
    required Function(NotificationSettings) onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => NotificationSettingsDialogWidget(
        settings: settings,
        onSave: onSave,
      ),
    );
  }

  // ===== HELP DIALOG =====
  static void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF6C63FF)),
            SizedBox(width: 8),
            Text('Centre d\'aide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('Comment réserver ?', 'Accédez à la section recherche...'),
              _buildHelpItem('Modifier une réservation', 'Allez dans Mes Réservations...'),
              _buildHelpItem('Politique d\'annulation', 'Vous pouvez annuler...'),
              _buildHelpItem('Mode de paiement', 'Nous acceptons...'),
            ],
          ),
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

  static Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  // ===== CONTACT DIALOG =====
  static void showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.contact_support, color: Color(0xFF6C63FF)),
            SizedBox(width: 8),
            Text('Nous contacter'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFF6C63FF)),
              title: Text('Email'),
              subtitle: Text('support@voyage.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xFF6C63FF)),
              title: Text('Téléphone'),
              subtitle: Text('+216 71 123 456'),
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Color(0xFF6C63FF)),
              title: Text('Chat en direct'),
              subtitle: Text('Disponible 24/7'),
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

  // ===== TERMS DIALOG =====
  static void showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conditions d\'utilisation'),
        content: SingleChildScrollView(
          child: Text(
            'Conditions générales d\'utilisation...\n\n'
            '1. Acceptation des conditions\n'
            '2. Utilisation du service\n'
            '3. Politique de confidentialité\n'
            '4. Responsabilités\n'
            '5. Modifications\n\n'
            'Dernière mise à jour: 01/01/2024',
          ),
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

  // ===== LOGOUT DIALOG =====
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Logique de déconnexion ici
            },
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}