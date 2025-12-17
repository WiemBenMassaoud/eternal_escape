import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  final Box settingsBox;
  final Function(String, dynamic) onUpdateSetting;

  const PrivacySettingsScreen({
    Key? key,
    required this.settingsBox,
    required this.onUpdateSetting,
  }) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
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
    dataSharing = widget.settingsBox.get('dataSharing', defaultValue: true);
    personalizedAds = widget.settingsBox.get('personalizedAds', defaultValue: false);
    usageAnalytics = widget.settingsBox.get('usageAnalytics', defaultValue: true);
    locationTracking = widget.settingsBox.get('locationTracking', defaultValue: true);
    marketingEmails = widget.settingsBox.get('marketingEmails', defaultValue: true);
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
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF6C63FF)), onPressed: () => Navigator.pop(context)),
        title: Text('Confidentialité', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
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
                gradient: LinearGradient(colors: [Color(0xFF06D6A0), Color(0xFF4ACFB0)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Color(0xFF06D6A0).withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Row(
                children: [
                  Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(Icons.security_rounded, color: Colors.white, size: 28)),
                  SizedBox(width: AppTheme.marginLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Confidentialité et Sécurité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text('Contrôlez vos données personnelles', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),

            Text('Paramètres de Confidentialité', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFFEAEAFF), width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.info_outline_rounded, color: Color(0xFF6C63FF)), SizedBox(width: 8), Text('Transparence des Données', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF333333)))]),
                  SizedBox(height: 12),
                  Text(
                    'Toutes vos données sont chiffrées de bout en bout et stockées sur des serveurs sécurisés. Nous ne vendons jamais vos informations personnelles à des tiers.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
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

  Widget _buildPrivacySwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFFEAEAFF), width: 1), boxShadow: [BoxShadow(color: Color(0xFF6C63FF).withOpacity(0.05), blurRadius: 15, offset: Offset(0, 8))]),
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
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
                      SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
                    ],
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                Switch(value: value, onChanged: onChanged, activeColor: Color(0xFF06D6A0), activeTrackColor: Color(0xFF06D6A0).withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}