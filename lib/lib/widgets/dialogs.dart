import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';

Future<void> showEmailPreferencesDialog({
  required BuildContext context,
  required Box settingsBox,
  required Function(String, dynamic) onUpdateSetting,
}) async {
  bool reservations = settingsBox.get('emailReservations', defaultValue: true);
  bool offers = settingsBox.get('emailOffers', defaultValue: true);
  bool news = settingsBox.get('emailNews', defaultValue: false);
  bool reviews = settingsBox.get('emailReviews', defaultValue: true);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD166).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFFFD166).withOpacity(0.2)),
                  ),
                  child: Icon(Icons.email_rounded, color: Color(0xFFFFD166), size: 22),
                ),
                SizedBox(width: 12),
                Text(
                  'Préférences email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333)),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEmailPreference('Réservations', 'Confirmations et rappels', reservations, (v) => setState(() => reservations = v)),
                  SizedBox(height: 12),
                  _buildEmailPreference('Offres spéciales', 'Promotions et réductions', offers, (v) => setState(() => offers = v)),
                  SizedBox(height: 12),
                  _buildEmailPreference('Nouvelles', 'Actualités et conseils', news, (v) => setState(() => news = v)),
                  SizedBox(height: 12),
                  _buildEmailPreference('Avis', 'Demandes d\'avis et évaluations', reviews, (v) => setState(() => reviews = v)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: TextStyle(color: Color(0xFF666666)))),
              ElevatedButton(
                onPressed: () {
                  onUpdateSetting('emailReservations', reservations);
                  onUpdateSetting('emailOffers', offers);
                  onUpdateSetting('emailNews', news);
                  onUpdateSetting('emailReviews', reviews);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD166),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

Widget _buildEmailPreference(String title, String subtitle, bool value, Function(bool) onChanged) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
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

void showChangePasswordDialog(BuildContext context) {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFFF6B6B).withOpacity(0.2)),
            ),
            child: Icon(Icons.lock_rounded, color: Color(0xFFFF6B6B), size: 22),
          ),
          SizedBox(width: 12),
          Text('Changer le mot de passe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPasswordController, obscureText: true, decoration: InputDecoration(labelText: 'Mot de passe actuel', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            SizedBox(height: 12),
            TextField(controller: newPasswordController, obscureText: true, decoration: InputDecoration(labelText: 'Nouveau mot de passe', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            SizedBox(height: 12),
            TextField(controller: confirmPasswordController, obscureText: true, decoration: InputDecoration(labelText: 'Confirmer le mot de passe', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
        ElevatedButton(
          onPressed: () {
            if (newPasswordController.text == confirmPasswordController.text) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white, size: 20), SizedBox(width: 8), Text('Mot de passe changé avec succès')]), backgroundColor: Color(0xFF06D6A0)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Les mots de passe ne correspondent pas'), backgroundColor: Colors.red));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: Text('Changer'),
        ),
      ],
    ),
  );
}

Future<void> showAboutDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFFD166).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFFFD166).withOpacity(0.2)),
            ),
            child: Icon(Icons.info_rounded, color: Color(0xFFFFD166), size: 22),
          ),
          SizedBox(width: 12),
          Text('À propos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
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
                gradient: LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF857BFF)]),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.hotel_rounded, color: Colors.white, size: 40),
            ),
            SizedBox(height: 16),
            Text('Eternal Escape', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
            SizedBox(height: 4),
            Text('v1.0.0', style: TextStyle(color: Color(0xFF666666))),
            SizedBox(height: 16),
            Text('Votre application de réservation d\'hôtels et logements de luxe en Tunisie.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xFFF8F9FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFEAEAFF))),
              child: Column(
                children: [
                  Text('Informations légales', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Version', style: TextStyle(fontSize: 12, color: Color(0xFF666666))), Text('1.0.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
                  SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Dernière mise à jour', style: TextStyle(fontSize: 12, color: Color(0xFF666666))), Text('2024', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
                  SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Développeur', style: TextStyle(fontSize: 12, color: Color(0xFF666666))), Text('Eternal Escape Team', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Fermer'))],
    ),
  );
}

Future<void> makePhoneCallFromDialog(BuildContext context, String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible de composer le numéro'), backgroundColor: Colors.red));
  }
}

Future<void> sendEmailFromDialog(BuildContext context, String email) async {
  final url = 'mailto:$email';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'ouvrir l\'application email'), backgroundColor: Colors.red));
  }
}