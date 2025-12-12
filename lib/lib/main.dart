import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/theme.dart';
import 'models/logement.dart';
import 'models/reservation.dart';
import 'models/favorite.dart';
import 'models/user.dart';
import 'models/preferences.dart';
import 'models/security_settings.dart';
import 'models/notification_settings.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/chat_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialisation Hive
  await Hive.initFlutter();

  // Enregistrement des adapters Hive avec typeId uniques
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(LogementAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ReservationAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(FavoriteAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(UserAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(PreferencesAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(SecuritySettingsAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(NotificationSettingsAdapter());

  // Ouverture des boxes
  await Hive.openBox<Logement>('logements');
  await Hive.openBox<Reservation>('reservations');
  await Hive.openBox<Favorite>('favorites');
  await Hive.openBox<User>('users');
  await Hive.openBox<Preferences>('preferences');
  await Hive.openBox<SecuritySettings>('security_settings');
  await Hive.openBox<NotificationSettings>('notification_settings');
  await Hive.openBox('settings');
  await Hive.openBox('connected_devices');
  await ChatStorage.init();
  runApp(const EasyTravelApp());
}

class EasyTravelApp extends StatelessWidget {
  const EasyTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EternalEscape Tunisie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const WelcomeScreen(), // ✅ Commencer par WelcomeScreen
      routes: {
        '/home': (context) => const MainScreen(),
      },
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

  final List<Widget> _pages = [
    HomeScreen(),
    const FavoritesPage(),
    BookingScreen(),
    const ProfileScreen(), // ✅ CHANGE ICI ProfilePage() → ProfileScreen()
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