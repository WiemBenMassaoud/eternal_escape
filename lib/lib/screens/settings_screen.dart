import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Box? settingsBox;

  bool get biometricAuth =>
      settingsBox?.get('biometricAuth', defaultValue: true) ?? true;
  bool get emailReservations =>
      settingsBox?.get('emailReservations', defaultValue: true) ?? true;
  bool get emailOffers =>
      settingsBox?.get('emailOffers', defaultValue: true) ?? true;
  bool get emailNews =>
      settingsBox?.get('emailNews', defaultValue: false) ?? false;
  bool get emailReviews =>
      settingsBox?.get('emailReviews', defaultValue: true) ?? true;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    settingsBox = await Hive.openBox('settings');
    setState(() {});
  }

  void _updateSetting(String key, dynamic value) {
    settingsBox?.put(key, value);
    setState(() {}); // refresh UI
    _showSuccessSnackbar('Paramètre mis à jour');
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Color(0xFF06D6A0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF6C63FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body:
          (settingsBox?.isOpen ?? false) ? _buildContent() : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingXXL),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.paddingLG),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.settings_rounded,
                            color: Colors.white, size: 28),
                      ),
                      SizedBox(width: AppTheme.marginLG),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paramètres',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Personnalisez votre expérience',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.marginXXL),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return _buildSettingsSection('Compte', [
                  _buildSettingItem(
                    Icons.notifications_rounded,
                    'Notifications',
                    'Gérer vos préférences',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsScreen()),
                    ),
                    Color(0xFF36D1DC),
                  ),
                  _buildSettingItem(
                    Icons.email_rounded,
                    'Préférences email',
                    'Choisir les emails reçus',
                    () => _showEmailPreferencesDialog(),
                    Color(0xFFFFD166),
                  ),
                ]);
              } else if (index == 1) {
                return _buildSettingsSection('Sécurité', [
                  _buildSettingSwitch(
                    Icons.fingerprint_rounded,
                    'Authentification biométrique',
                    'Déverrouiller avec empreinte',
                    biometricAuth,
                    (value) => _updateSetting('biometricAuth', value),
                    Color(0xFF7C4DFF),
                  ),
                  _buildSettingItem(
                    Icons.lock_rounded,
                    'Changer le mot de passe',
                    'Mettre à jour votre mot de passe',
                    () => _showChangePasswordDialog(),
                    Color(0xFFFF6B6B),
                  ),
                  _buildSettingItem(
                    Icons.security_rounded,
                    'Confidentialité',
                    'Gérer vos données personnelles',
                    () => _showPrivacySettings(),
                    Color(0xFF06D6A0),
                  ),
                ]);
              } else if (index == 2) {
                return _buildSettingsSection('Application', [
                  _buildSettingItem(
                    Icons.help_rounded,
                    'Aide & Support',
                    'FAQ, contact et assistance',
                    () => _showHelpAndSupportFull(),
                    Color(0xFF6C63FF),
                  ),
                  _buildSettingItem(
                    Icons.info_rounded,
                    'À propos',
                    'Informations sur l\'application',
                    () => showAppAboutDialog(context),
                    Color(0xFFFFD166),
                  ),
                ]);
              } else {
                return Padding(
                  padding: EdgeInsets.all(AppTheme.paddingXXL),
                  child: Column(
                    children: [
                      SizedBox(height: AppTheme.marginXXL),
                      Text(
                        'Eternal Escape v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            childCount: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.paddingXXL,
        vertical: AppTheme.marginLG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: AppTheme.marginLG),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle,
      VoidCallback onTap, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEAEAFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: AppTheme.marginLG),
                Expanded(
                  child: Column(
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
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFEAEAFF),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(IconData icon, String title, String subtitle,
      bool value, Function(bool) onChanged, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEAEAFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: AppTheme.marginLG),
                Expanded(
                  child: Column(
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
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Color(0xFF6C63FF),
                  activeTrackColor: Color(0xFF6C63FF).withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailPreferencesDialog() {
    bool reservations = emailReservations;
    bool offers = emailOffers;
    bool news = emailNews;
    bool reviews = emailReviews;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
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
                      color: Color(0xFFFFD166).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color(0xFFFFD166).withOpacity(0.2)),
                    ),
                    child: Icon(Icons.email_rounded,
                        color: Color(0xFFFFD166), size: 22),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Préférences email',
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
                    _buildEmailPreference(
                      'Réservations',
                      'Confirmations et rappels',
                      reservations,
                      (value) => setState(() => reservations = value),
                    ),
                    SizedBox(height: 12),
                    _buildEmailPreference(
                      'Offres spéciales',
                      'Promotions et réductions',
                      offers,
                      (value) => setState(() => offers = value),
                    ),
                    SizedBox(height: 12),
                    _buildEmailPreference(
                      'Nouvelles',
                      'Actualités et conseils',
                      news,
                      (value) => setState(() => news = value),
                    ),
                    SizedBox(height: 12),
                    _buildEmailPreference(
                      'Avis',
                      'Demandes d\'avis et évaluations',
                      reviews,
                      (value) => setState(() => reviews = value),
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
                    _updateSetting('emailReservations', reservations);
                    _updateSetting('emailOffers', offers);
                    _updateSetting('emailNews', news);
                    _updateSetting('emailReviews', reviews);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD166),
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
      },
    );
  }

  Widget _buildEmailPreference(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFFD166),
          activeTrackColor: Color(0xFFFFD166).withOpacity(0.3),
        ),
      ],
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Color(0xFFFF6B6B).withOpacity(0.2)),
              ),
              child: Icon(Icons.lock_rounded,
                  color: Color(0xFFFF6B6B), size: 22),
            ),
            SizedBox(width: 12),
            Text(
              'Changer le mot de passe',
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
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFEAEAFF)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                Navigator.pop(context);
                _showSuccessSnackbar('Mot de passe changé avec succès');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Les mots de passe ne correspondent pas'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PrivacySettingsScreen(
          settingsBox: settingsBox!,
          onUpdateSetting: _updateSetting,
        ),
      ),
    );
  }

  void _showHelpAndSupportFull() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _HelpAndSupportScreen(),
      ),
    );
  }

  // Updated to use the new names: showAppAboutDialog (to avoid clash with Flutter)
  Future<void> showAppAboutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFFD166).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Color(0xFFFFD166).withOpacity(0.2)),
              ),
              child: Icon(Icons.info_rounded,
                  color: Color(0xFFFFD166), size: 22),
            ),
            SizedBox(width: 12),
            Text(
              'À propos',
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hotel_rounded,
                    color: Colors.white, size: 40),
              ),
              SizedBox(height: 16),
              Text(
                'Eternal Escape',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'v1.0.0',
                style: TextStyle(
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Votre application de réservation d\'hôtels et logements de luxe en Tunisie.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFEAEAFF)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Informations légales',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Version',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        Text('1.0.0',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dernière mise à jour',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        Text('2024',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Développeur',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        Text('Eternal Escape Team',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
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

  // Use Uri-based launch helpers (current url_launcher API)
  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de composer le numéro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'ouvrir l\'application email'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/* ---------------------------
   Privacy screen (internal)
   --------------------------- */
class _PrivacySettingsScreen extends StatefulWidget {
  final Box settingsBox;
  final Function(String, dynamic) onUpdateSetting;

  const _PrivacySettingsScreen({
    required this.settingsBox,
    required this.onUpdateSetting,
  });

  @override
  State<_PrivacySettingsScreen> createState() =>
      _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<_PrivacySettingsScreen> {
  late bool dataSharing;
  late bool personalizedAds;
  late bool usageAnalytics;
  late bool locationTracking;
  late bool marketingEmails;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    dataSharing =
        widget.settingsBox.get('dataSharing', defaultValue: true);
    personalizedAds =
        widget.settingsBox.get('personalizedAds', defaultValue: false);
    usageAnalytics =
        widget.settingsBox.get('usageAnalytics', defaultValue: true);
    locationTracking =
        widget.settingsBox.get('locationTracking', defaultValue: true);
    marketingEmails =
        widget.settingsBox.get('marketingEmails', defaultValue: true);
  }

  void _updateSetting(String key, bool value) {
    widget.settingsBox.put(key, value);
    widget.onUpdateSetting(key, value);
    setState(() {
      switch (key) {
        case 'dataSharing':
          dataSharing = value;
          break;
        case 'personalizedAds':
          personalizedAds = value;
          break;
        case 'usageAnalytics':
          usageAnalytics = value;
          break;
        case 'locationTracking':
          locationTracking = value;
          break;
        case 'marketingEmails':
          marketingEmails = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xFF6C63FF)),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Confidentialité',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.paddingXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.paddingLG),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF06D6A0), Color(0xFF4ACFB0)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF06D6A0).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.security_rounded,
                        color: Colors.white, size: 28),
                  ),
                  SizedBox(width: AppTheme.marginLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confidentialité et Sécurité',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Contrôlez vos données personnelles',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),
            Text(
              'Paramètres de Confidentialité',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: AppTheme.marginLG),
            _buildPrivacySwitch(
              'Partage de Données avec les Partenaires',
              'Autorisez le partage de données anonymisées avec nos partenaires pour améliorer votre expérience.',
              dataSharing,
              (value) => _updateSetting('dataSharing', value),
            ),
            SizedBox(height: AppTheme.marginMD),
            _buildPrivacySwitch(
              'Publicités Personnalisées',
              'Recevez des publicités adaptées à vos préférences et intérêts.',
              personalizedAds,
              (value) => _updateSetting('personalizedAds', value),
            ),
            SizedBox(height: AppTheme.marginMD),
            _buildPrivacySwitch(
              'Analytique d\'Utilisation',
              'Partagez des données d\'utilisation pour nous aider à améliorer l\'application.',
              usageAnalytics,
              (value) => _updateSetting('usageAnalytics', value),
            ),
            SizedBox(height: AppTheme.marginMD),
            _buildPrivacySwitch(
              'Suivi de Localisation',
              'Autorisez l\'accès à votre localisation pour des recommandations personnalisées.',
              locationTracking,
              (value) => _updateSetting('locationTracking', value),
            ),
            SizedBox(height: AppTheme.marginMD),
            _buildPrivacySwitch(
              'Emails Marketing',
              'Recevez des offres spéciales et des nouvelles par email.',
              marketingEmails,
              (value) => _updateSetting('marketingEmails', value),
            ),
            SizedBox(height: AppTheme.marginXXL),
            Container(
              padding: EdgeInsets.all(AppTheme.paddingLG),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFFEAEAFF),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Color(0xFF6C63FF)),
                      SizedBox(width: 8),
                      Text(
                        'Transparence des Données',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Toutes vos données sont chiffrées de bout en bout et stockées sur des serveurs sécurisés. Nous ne vendons jamais vos informations personnelles à des tiers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySwitch(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEAEAFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Expanded(
                  child: Column(
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
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Color(0xFF06D6A0),
                  activeTrackColor:
                      Color(0xFF06D6A0).withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------------------
   Help & Support screen (internal)
   --------------------------- */
class _HelpAndSupportScreen extends StatelessWidget {
  const _HelpAndSupportScreen({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de composer le numéro'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir l\'application email'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF6C63FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Aide & Support',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.paddingXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.paddingLG),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.help_rounded, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: AppTheme.marginLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Centre d\'Aide',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Trouvez rapidement des réponses à vos questions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),

            Text(
              'Support Direct',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: AppTheme.marginLG),

            _buildSupportCard(
              context,
              Icons.chat_bubble_outline_rounded,
              'Chat en Direct',
              'Discutez avec un agent en temps réel',
              '+216 70 000 001',
              'Lundi-Vendredi: 8h-20h',
              Icons.phone_rounded,
              () => _makePhoneCall(context, '+21670000001'),
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildSupportCard(
              context,
              Icons.email_rounded,
              'Email de Support',
              'Envoyez-nous un email détaillé',
              'support@eternalescape.com',
              'Réponse sous 24h',
              Icons.email_rounded,
              () => _sendEmail(context, 'support@eternalescape.com'),
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildSupportCard(
              context,
              Icons.phone_rounded,
              'Hotline Urgence',
              'Support 24h/24 pour les urgences',
              '+216 70 000 002',
              'Disponible 24h/24, 7j/7',
              Icons.phone_rounded,
              () => _makePhoneCall(context, '+21670000002'),
            ),
            SizedBox(height: AppTheme.marginXXL),

            Text(
              'FAQ - Questions Fréquentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: AppTheme.marginLG),

            _buildFAQItem(
              'Comment modifier une réservation ?',
              'Rendez-vous dans "Mes Réservations", sélectionnez la réservation et cliquez sur "Modifier". Les modifications sont possibles jusqu\'à 48h avant l\'arrivée.',
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem(
              'Comment annuler une réservation ?',
              'Rendez-vous dans "Mes Réservations", sélectionnez la réservation et cliquez sur "Annuler". Les annulations sont gratuites jusqu\'à 24h avant l\'arrivée selon la politique de l\'hôtel.',
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem(
              'Comment contacter l\'hôtel directement ?',
              'Dans les détails de votre réservation, vous trouverez les coordonnées directes de l\'hôtel. Vous pouvez également utiliser notre messagerie intégrée.',
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem(
              'Problème de paiement ?',
              'Vérifiez que votre carte est valide et que les fonds sont suffisants. Si le problème persiste, contactez votre banque ou notre support.',
            ),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem(
              'Comment utiliser mes points de fidélité ?',
              'Vos points s\'affichent dans votre profil. Au moment du paiement, sélectionnez "Utiliser mes points" pour les appliquer à votre réservation.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String contact,
    String hours,
    IconData actionIcon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEAEAFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFF6C63FF).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: Color(0xFF6C63FF), size: 24),
                ),
                SizedBox(width: AppTheme.marginLG),
                Expanded(
                  child: Column(
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
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded,
                              size: 14, color: Color(0xFF666666)),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              contact,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Color(0xFF666666)),
                          SizedBox(width: 4),
                          Text(
                            hours,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(actionIcon, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEAEAFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(AppTheme.paddingLG),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF6C63FF).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF6C63FF).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(Icons.question_mark_rounded,
              color: Color(0xFF6C63FF), size: 20),
        ),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                AppTheme.paddingLG, 0, AppTheme.paddingLG, AppTheme.paddingLG),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}