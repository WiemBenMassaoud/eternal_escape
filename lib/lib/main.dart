import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'models/logement.dart';
import 'models/reservation.dart';
import 'models/favorite.dart';
import 'models/user.dart' hide User;
import 'models/preferences.dart';
import 'models/security_settings.dart';
import 'models/notification_settings.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'services/chat_storage.dart';

void main() async {
  // Configuration de l'orientation et des overlays système
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialisation de Hive
  await Hive.initFlutter();
  
  // ============================================================
  // 🧹 NETTOYAGE TOTAL (optionnel - commenter après le premier lancement)
  // ============================================================
  print('🧹 Nettoyage des données Hive...');
  
  try {
    // Fermer toutes les boxes ouvertes
    final boxNames = ['reservations', 'logements', 'favorites', 'users', 'preferences', 'security_settings', 'notification_settings', 'settings', 'connected_devices'];
    for (var boxName in boxNames) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    }
    
    // ⚠️ DÉCOMMENTER SEULEMENT SI VOUS VOULEZ SUPPRIMER TOUTES LES DONNÉES
    // for (var boxName in boxNames) {
    //   try {
    //     await Hive.deleteBoxFromDisk(boxName);
    //   } catch (e) {
    //     print('Box $boxName n\'existe pas');
    //   }
    // }
    
    print('✅ Boxes nettoyées avec succès');
  } catch (e) {
    print('⚠️ Erreur lors du nettoyage: $e');
  }
  
  // ============================================================
  // 📦 ENREGISTREMENT DES ADAPTATEURS
  // ============================================================
  print('📦 Enregistrement des adaptateurs...');
  
  try {
    // LogementAdapter (typeId: 0)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LogementAdapter());
      print('✅ LogementAdapter enregistré (typeId: 0)');
    } else {
      print('ℹ️ LogementAdapter déjà enregistré');
    }
    
    // ReservationAdapter (typeId: 1)
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ReservationAdapter());
      print('✅ ReservationAdapter enregistré (typeId: 1)');
    } else {
      print('ℹ️ ReservationAdapter déjà enregistré');
    }
    
    // FavoriteAdapter (typeId: 2)
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(FavoriteAdapter());
      print('✅ FavoriteAdapter enregistré (typeId: 2)');
    } else {
      print('ℹ️ FavoriteAdapter déjà enregistré');
    }
    
    // UserAdapter (typeId: 3)
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserAdapter());
      print('✅ UserAdapter enregistré (typeId: 3)');
    } else {
      print('ℹ️ UserAdapter déjà enregistré');
    }
    
    // PreferencesAdapter (typeId: 4)
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(PreferencesAdapter());
      print('✅ PreferencesAdapter enregistré (typeId: 4)');
    } else {
      print('ℹ️ PreferencesAdapter déjà enregistré');
    }
    
    // SecuritySettingsAdapter (typeId: 5)
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SecuritySettingsAdapter());
      print('✅ SecuritySettingsAdapter enregistré (typeId: 5)');
    } else {
      print('ℹ️ SecuritySettingsAdapter déjà enregistré');
    }
    
    // NotificationSettingsAdapter (typeId: 6)
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(NotificationSettingsAdapter());
      print('✅ NotificationSettingsAdapter enregistré (typeId: 6)');
    } else {
      print('ℹ️ NotificationSettingsAdapter déjà enregistré');
    }
  } catch (e) {
    print('❌ Erreur lors de l\'enregistrement des adapters: $e');
  }
  
  // ============================================================
  // 🔓 OUVERTURE DES BOXES
  // ============================================================
  print('🔓 Ouverture des boxes...');
  
  try {
    await Hive.openBox<Logement>('logements');
    print('✅ Box logements ouverte');
    
    await Hive.openBox<Reservation>('reservations');
    print('✅ Box reservations ouverte');
    
    await Hive.openBox<Favorite>('favorites');
    print('✅ Box favorites ouverte');
    
    await Hive.openBox<User>('users');
    print('✅ Box users ouverte');
    
    await Hive.openBox<Preferences>('preferences');
    print('✅ Box preferences ouverte');
    
    await Hive.openBox<SecuritySettings>('security_settings');
    print('✅ Box security_settings ouverte');
    
    await Hive.openBox<NotificationSettings>('notification_settings');
    print('✅ Box notification_settings ouverte');
    
    await Hive.openBox('settings');
    print('✅ Box settings ouverte');
    
    await Hive.openBox('connected_devices');
    print('✅ Box connected_devices ouverte');
    
    await ChatStorage.init();
    print('✅ ChatStorage initialisé');
    
    print('🎉 Initialisation Hive terminée avec succès!');
  } catch (e, stack) {
    print('❌ ERREUR CRITIQUE lors de l\'ouverture des boxes:');
    print('Erreur: $e');
    print('Stack trace:');
    print(stack);
    
    runApp(ErrorApp(error: e.toString()));
    return;
  }
  
  // ============================================================
  // ✅ INITIALISATION DU FAVORITESERVICE
  // ============================================================
  print('🚀 Initialisation du FavoriteService...');
  
  final favoriteService = FavoriteService();
  try {
    await favoriteService.init();
    print('✅ FavoriteService initialisé avec succès');
  } catch (e) {
    print('❌ Erreur lors de l\'initialisation du FavoriteService: $e');
    runApp(ErrorApp(error: 'Erreur FavoriteService: ${e.toString()}'));
    return;
  }
  
  // ============================================================
  // 🎯 LANCEMENT DE L'APPLICATION
  // ============================================================
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider<FavoriteService>.value(value: favoriteService),
      ],
      child: const EasyTravelApp(),
    ),
  );
}

/// Widget affiché en cas d'erreur critique
class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 24),
                Text(
                  'Erreur d\'initialisation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Redémarrer l\'application'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  
  // Liste des pages
  final List<Widget> _pages = [
    HomeScreen(),
    const FavoritesPage(), // Utilise le FavoritesPage existant
    BookingScreen(),
    const SettingsScreen(),
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
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Paramètres',
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

// Page Favoris (copiée de votre deuxième version)
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