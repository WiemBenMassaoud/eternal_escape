// lib/utils/dialog_widgets.dart
// Ce fichier contient les widgets StatefulWidget pour les dialogs complexes
import 'package:flutter/material.dart';
import '../models/preferences.dart';
import '../models/security_settings.dart';
import '../models/notification_settings.dart';

// ===== SECURITY & PRIVACY DIALOG =====
class SecurityPrivacyDialogWidget extends StatefulWidget {
  final SecuritySettings settings;
  final List<Map<String, dynamic>> devices;
  final Function(SecuritySettings) onSecurityChanged;
  final Function(List<Map<String, dynamic>>) onDevicesChanged;

  const SecurityPrivacyDialogWidget({
    Key? key,
    required this.settings,
    required this.devices,
    required this.onSecurityChanged,
    required this.onDevicesChanged,
  }) : super(key: key);

  @override
  State<SecurityPrivacyDialogWidget> createState() => _SecurityPrivacyDialogState();
}

class _SecurityPrivacyDialogState extends State<SecurityPrivacyDialogWidget> {
  late SecuritySettings _settings;
  late List<Map<String, dynamic>> _devices;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _devices = List.from(widget.devices);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sécurité et Confidentialité'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Authentification à deux facteurs'),
              subtitle: Text('Ajouter une couche de sécurité'),
              value: _settings.twoFactorEnabled,
              onChanged: (val) {
                setState(() => _settings.twoFactorEnabled = val);
              },
            ),
            SwitchListTile(
              title: Text('Connexion biométrique'),
              subtitle: Text('Utiliser empreinte/Face ID'),
              value: _settings.biometricLogin,
              onChanged: (val) {
                setState(() => _settings.biometricLogin = val);
              },
            ),
            SwitchListTile(
              title: Text('Déconnexion automatique'),
              subtitle: Text('Après 30 min d\'inactivité'),
              value: _settings.autoLogout,
              onChanged: (val) {
                setState(() => _settings.autoLogout = val);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.devices),
              title: Text('Appareils connectés'),
              subtitle: Text('${_devices.length} appareil(s)'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showAllDevicesDialog(),
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
            widget.onSecurityChanged(_settings);
            Navigator.pop(context);
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }

  void _showAllDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appareils connectés'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              return ListTile(
                leading: Icon(
                  device['type'] == 'mobile' ? Icons.phone_android : Icons.laptop,
                ),
                title: Text(device['name']),
                subtitle: Text(device['location']),
                trailing: IconButton(
                  icon: Icon(Icons.logout, color: Colors.red),
                  onPressed: () => _logoutDevice(index),
                ),
              );
            },
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

  void _logoutDevice(int index) {
    setState(() {
      _devices.removeAt(index);
    });
    widget.onDevicesChanged(_devices);
    Navigator.pop(context);
  }
}

// ===== PREFERENCES DIALOG =====
class PreferencesDialogWidget extends StatefulWidget {
  final Preferences preferences;
  final Function(Preferences) onSave;

  const PreferencesDialogWidget({
    Key? key,
    required this.preferences,
    required this.onSave,
  }) : super(key: key);

  @override
  State<PreferencesDialogWidget> createState() => _PreferencesDialogState();
}

class _PreferencesDialogState extends State<PreferencesDialogWidget> {
  late Preferences _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = widget.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Préférences'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Langue'),
              subtitle: Text(_prefs.language),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showLanguageSelector(),
            ),
            ListTile(
              title: Text('Devise'),
              subtitle: Text(_prefs.currency),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showCurrencySelector(),
            ),
            ListTile(
              title: Text('Thème'),
              subtitle: Text(_prefs.theme),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showThemeSelector(),
            ),
            SwitchListTile(
              title: Text('Services de localisation'),
              value: _prefs.locationServices,
              onChanged: (val) {
                setState(() => _prefs.locationServices = val);
              },
            ),
            SwitchListTile(
              title: Text('Synchronisation automatique'),
              value: _prefs.autoSync,
              onChanged: (val) {
                setState(() => _prefs.autoSync = val);
              },
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
            widget.onSave(_prefs);
            Navigator.pop(context);
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Français', 'English', 'العربية'].map((lang) {
            return RadioListTile(
              title: Text(lang),
              value: lang,
              groupValue: _prefs.language,
              onChanged: (val) {
                setState(() => _prefs.language = val!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir la devise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['TND', 'EUR', 'USD'].map((currency) {
            return RadioListTile(
              title: Text(currency),
              value: currency,
              groupValue: _prefs.currency,
              onChanged: (val) {
                setState(() => _prefs.currency = val!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir le thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Clair', 'Sombre', 'Automatique'].map((theme) {
            return RadioListTile(
              title: Text(theme),
              value: theme,
              groupValue: _prefs.theme,
              onChanged: (val) {
                setState(() => _prefs.theme = val!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ===== NOTIFICATION SETTINGS DIALOG =====
class NotificationSettingsDialogWidget extends StatefulWidget {
  final NotificationSettings settings;
  final Function(NotificationSettings) onSave;

  const NotificationSettingsDialogWidget({
    Key? key,
    required this.settings,
    required this.onSave,
  }) : super(key: key);

  @override
  State<NotificationSettingsDialogWidget> createState() => _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState extends State<NotificationSettingsDialogWidget> {
  late NotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Notifications'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Notifications de réservation'),
              value: _settings.reservationNotifications,
              onChanged: (val) {
                setState(() => _settings.reservationNotifications = val);
              },
            ),
            SwitchListTile(
              title: Text('Promotions et offres'),
              value: _settings.promotionNotifications,
              onChanged: (val) {
                setState(() => _settings.promotionNotifications = val);
              },
            ),
            SwitchListTile(
              title: Text('Newsletter'),
              value: _settings.newsletter,
              onChanged: (val) {
                setState(() => _settings.newsletter = val);
              },
            ),
            SwitchListTile(
              title: Text('Messages'),
              value: _settings.messageNotifications,
              onChanged: (val) {
                setState(() => _settings.messageNotifications = val);
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Notifications push'),
              value: _settings.pushNotifications,
              onChanged: (val) {
                setState(() => _settings.pushNotifications = val);
              },
            ),
            SwitchListTile(
              title: Text('Notifications email'),
              value: _settings.emailNotifications,
              onChanged: (val) {
                setState(() => _settings.emailNotifications = val);
              },
            ),
            SwitchListTile(
              title: Text('Notifications SMS'),
              value: _settings.smsNotifications,
              onChanged: (val) {
                setState(() => _settings.smsNotifications = val);
              },
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
            widget.onSave(_settings);
            Navigator.pop(context);
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }
}