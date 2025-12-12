import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../widgets/setting_switch.dart';
import '../../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool pushNotifications = true;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Réservation confirmée',
      'message': 'Votre réservation à La Marsa a été confirmée.',
      'time': 'Il y a 2 heures',
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF6C63FF),
      'read': false,
    },
    {
      'title': 'Paiement réussi',
      'message': 'Votre paiement de 1,200€ a été traité.',
      'time': 'Il y a 1 jour',
      'icon': Icons.payment_rounded,
      'color': Color(0xFF36D1DC),
      'read': true,
    },
    {
      'title': 'Nouveau message',
      'message': 'Vous avez reçu un message du propriétaire.',
      'time': 'Il y a 2 jours',
      'icon': Icons.chat_bubble_rounded,
      'color': Color(0xFFFF6B6B),
      'read': false,
    },
    {
      'title': 'Rappel de séjour',
      'message': 'Votre séjour commence dans 3 jours.',
      'time': 'Il y a 3 jours',
      'icon': Icons.calendar_today_rounded,
      'color': Color(0xFF7C4DFF),
      'read': true,
    },
    {
      'title': 'Offre spéciale',
      'message': 'Réduction de 20% sur votre prochain séjour.',
      'time': 'Il y a 1 semaine',
      'icon': Icons.local_offer_rounded,
      'color': Color(0xFFFFD166),
      'read': true,
    },
    {
      'title': 'Avis demandé',
      'message': 'Donnez votre avis sur votre dernier séjour.',
      'time': 'Il y a 2 semaines',
      'icon': Icons.star_rounded,
      'color': Color(0xFF06D6A0),
      'read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: Material(
            color: Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primary, size: 20),
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Header Card
                  FadeTransition(
                    opacity: _animationController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: Container(
                        padding: EdgeInsets.all(AppTheme.paddingLG + 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6C63FF).withOpacity(0.4),
                              blurRadius: 25,
                              offset: Offset(0, 12),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.notifications_active_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            SizedBox(width: AppTheme.marginLG),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paramètres de notifications',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Gérez vos préférences',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.95),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.marginXXL + 4),

                  // Settings Section Title
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Paramètres',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.marginLG),

                  // Enhanced Setting Switches
                  SettingSwitchTile(
                    title: 'Notifications activées',
                    subtitle: 'Recevoir toutes les notifications',
                    value: notificationsEnabled,
                    icon: Icons.notifications_rounded,
                    onChanged: (v) => setState(() => notificationsEnabled = v),
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  SettingSwitchTile(
                    title: 'Notifications par email',
                    subtitle: 'Recevoir les emails de notification',
                    value: emailNotifications,
                    icon: Icons.email_rounded,
                    onChanged: (v) => setState(() => emailNotifications = v),
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  SettingSwitchTile(
                    title: 'Notifications push',
                    subtitle: 'Recevoir les notifications push',
                    value: pushNotifications,
                    icon: Icons.phone_iphone_rounded,
                    onChanged: (v) => setState(() => pushNotifications = v),
                  ),

                  SizedBox(height: AppTheme.marginXXL + 4),

                  // All notifications header + action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Toutes les notifications',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C63FF).withOpacity(0.1), Color(0xFF857BFF).withOpacity(0.1)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton.icon(
                          onPressed: _markAllAsRead,
                          icon: Icon(Icons.done_all_rounded, size: 18),
                          label: Text('Tout marquer'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.marginLG),
                ],
              ),
            ),
          ),

          // Notification list with stagger animation
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final n = notifications[index];
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (index / notifications.length) * 0.5,
                        ((index + 1) / notifications.length) * 0.5 + 0.5,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index / notifications.length) * 0.5,
                          ((index + 1) / notifications.length) * 0.5 + 0.5,
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingXXL,
                        vertical: AppTheme.marginSM,
                      ),
                      child: NotificationCard(
                        icon: n['icon'] as IconData,
                        title: n['title'] as String,
                        message: n['message'] as String,
                        time: n['time'] as String,
                        isRead: (n['read'] as bool?) ?? false,
                        iconColor: n['color'] as Color?,
                        onTap: () => _markAsRead(index),
                      ),
                    ),
                  ),
                );
              },
              childCount: notifications.length,
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  void _markAsRead(int index) {
    if (notifications[index]['read'] == true) return;
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Toutes les notifications marquées comme lues',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }
}