import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/theme.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible de composer le numéro'), backgroundColor: Colors.red));
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'ouvrir l\'application email'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF6C63FF)), onPressed: () => Navigator.pop(context)),
        title: Text('Aide & Support', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
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
                gradient: LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF857BFF)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Color(0xFF6C63FF).withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Row(
                children: [
                  Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(Icons.help_rounded, color: Colors.white, size: 28)),
                  SizedBox(width: AppTheme.marginLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Centre d\'Aide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text('Trouvez rapidement des réponses à vos questions', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),

            Text('Support Direct', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
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

            Text('FAQ - Questions Fréquentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333))),
            SizedBox(height: AppTheme.marginLG),

            _buildFAQItem('Comment modifier une réservation ?', 'Rendez-vous dans "Mes Réservations", sélectionnez la réservation et cliquez sur "Modifier". Les modifications sont possibles jusqu\'à 48h avant l\'arrivée.'),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem('Comment annuler une réservation ?', 'Rendez-vous dans "Mes Réservations", sélectionnez la réservation et cliquez sur "Annuler". Les annulations sont gratuites jusqu\'à 24h avant l\'arrivée selon la politique de l\'hôtel.'),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem('Comment contacter l\'hôtel directement ?', 'Dans les détails de votre réservation, vous trouverez les coordonnées directes de l\'hôtel. Vous pouvez également utiliser notre messagerie intégrée.'),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem('Problème de paiement ?', 'Vérifiez que votre carte est valide et que les fonds sont suffisants. Si le problème persiste, contactez votre banque ou notre support.'),
            SizedBox(height: AppTheme.marginMD),

            _buildFAQItem('Comment utiliser mes points de fidélité ?', 'Vos points s\'affichent dans votre profil. Au moment du paiement, sélectionnez "Utiliser mes points" pour les appliquer à votre réservation.'),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFFEAEAFF), width: 1), boxShadow: [BoxShadow(color: Color(0xFF6C63FF).withOpacity(0.05), blurRadius: 15, offset: Offset(0, 8))]),
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
                  decoration: BoxDecoration(color: Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF6C63FF).withOpacity(0.2), width: 1)),
                  child: Icon(icon, color: Color(0xFF6C63FF), size: 24),
                ),
                SizedBox(width: AppTheme.marginLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
                      SizedBox(height: 4),
                      Text(description, style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded, size: 14, color: Color(0xFF666666)),
                          SizedBox(width: 4),
                          Expanded(child: Text(contact, style: TextStyle(fontSize: 12, color: Color(0xFF666666)))),
                          SizedBox(width: 12),
                          Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF666666)),
                          SizedBox(width: 4),
                          Text(hours, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF6C63FF), shape: BoxShape.circle), child: Icon(actionIcon, color: Colors.white, size: 20)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFFEAEAFF), width: 1), boxShadow: [BoxShadow(color: Color(0xFF6C63FF).withOpacity(0.05), blurRadius: 15, offset: Offset(0, 8))]),
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(AppTheme.paddingLG),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Color(0xFF6C63FF).withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Color(0xFF6C63FF).withOpacity(0.2), width: 1)),
          child: Icon(Icons.question_mark_rounded, color: Color(0xFF6C63FF), size: 20),
        ),
        title: Text(question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(AppTheme.paddingLG, 0, AppTheme.paddingLG, AppTheme.paddingLG),
            child: Text(answer, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          ),
        ],
      ),
    );
  }
}