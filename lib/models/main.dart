import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/theme.dart';
import 'models/logement.dart';
import 'models/reservation.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';

void main() async {
  // Configuration de l'orientation et des overlays système
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialisation de Hive
  await Hive.initFlutter();
  
  // Enregistrement des adaptateurs Hive
  Hive.registerAdapter(LogementAdapter());
  Hive.registerAdapter(ReservationAdapter());
  
  // Ouverture des boxes
  await Hive.openBox<Logement>('logements');
  await Hive.openBox<Reservation>('reservations');
  
  runApp(const EasyTravelApp());
}

class EasyTravelApp extends StatelessWidget {
  const EasyTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EternalEscape Tunisie',
      debugShowCheckedModeBanner: false,
      
      // Thèmes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Page d'accueil
      home: const MainScreen(),
    );
  }
}

/// Écran principal avec navigation bottom bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Liste des pages
  final List<Widget> _pages = [
    HomeScreen(),
    const FavoritesPage(),
    BookingScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingLG,
            vertical: AppTheme.paddingSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explorer',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                label: 'Favoris',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Voyages',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMD,
          vertical: AppTheme.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: AppTheme.iconMD,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.textTheme.labelSmall?.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page Favoris
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppTheme.marginLG),
            Text(
              'Aucun favori pour le moment',
              style: AppTheme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.marginSM),
            Text(
              'Ajoutez des logements à vos favoris',
              style: AppTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Page Profil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingXXL),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: AppTheme.shadowCard,
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.marginXL),
            
            Text(
              'Utilisateur Demo',
              style: AppTheme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.marginSM),
            Text(
              'demo@eternalescape.com',
              style: AppTheme.textTheme.bodyMedium,
            ),
            
            const SizedBox(height: AppTheme.marginXXXL),
            
            // Menu items
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.payment_outlined,
              title: 'Méthodes de paiement',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Paramètres',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Aide et support',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Déconnexion',
              onTap: () {},
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.error : AppTheme.textSecondary,
        ),
        title: Text(
          title,
          style: AppTheme.textTheme.titleMedium?.copyWith(
            color: isDestructive ? AppTheme.error : AppTheme.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppTheme.iconXS,
          color: AppTheme.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }
}