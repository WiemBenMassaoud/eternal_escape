import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'models/logement.dart';
import 'models/reservation.dart';
import 'models/favorite.dart';
import 'models/user.dart';
import 'models/preferences.dart';
import 'models/notification_settings.dart';
import 'screens/profile_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/chat_storage.dart';
import 'screens/booking_screen.dart';
import 'models/message.dart';
import 'models/conversation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  
  print('🧹 Nettoyage des données Hive...');
  
  try {
    final boxNames = ['reservations', 'logements', 'favorites', 'users', 'preferences', 'notification_settings', 'settings', 'connected_devices', 'chats'];
    for (var boxName in boxNames) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    }
    
    print('✅ Boxes nettoyées avec succès');
  } catch (e) {
    print('⚠️ Erreur lors du nettoyage: $e');
  }
  
  print('📦 Enregistrement des adaptateurs...');
  
  try {
    // ENREGISTRER NotificationSettingsAdapter
    Hive.registerAdapter(NotificationSettingsAdapter());
    print('✅ NotificationSettingsAdapter enregistré (typeId: 6)');
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LogementAdapter());
      print('✅ LogementAdapter enregistré (typeId: 0)');
    }
    
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ReservationAdapter());
      print('✅ ReservationAdapter enregistré (typeId: 1)');
    }
    
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(FavoriteAdapter());
      print('✅ FavoriteAdapter enregistré (typeId: 2)');
    }
    
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserAdapter());
      print('✅ UserAdapter enregistré (typeId: 3)');
    }
    
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(PreferencesAdapter());
      print('✅ PreferencesAdapter enregistré (typeId: 4)');
    }
    
    // AJOUTER LES ADAPTATEURS POUR LE CHAT
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(MessageAdapter());
      print('✅ MessageAdapter enregistré (typeId: 10)');
    }
    
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ConversationAdapter());
      print('✅ ConversationAdapter enregistré (typeId: 11)');
    }
    
    // VÉRIFICATION FINALE
    print('🔍 Vérification des adaptateurs enregistrés:');
    print('   NotificationSettings (6): ${Hive.isAdapterRegistered(6) ? "✅" : "❌"}');
  } catch (e) {
    print('❌ Erreur lors de l\'enregistrement des adapters: $e');
  }
  
  print('🔓 Ouverture des boxes...');
  
  try {
    // OUVREZ notification_settings EN PREMIER
    print('📦 Ouverture de notification_settings...');
    await Hive.openBox<NotificationSettings>('notification_settings');
    print('✅ Box notification_settings ouverte');
    
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
    
    await Hive.openBox('settings');
    print('✅ Box settings ouverte');
    
    await Hive.openBox('connected_devices');
    print('✅ Box connected_devices ouverte');
    
    // Ouvrir la box pour le chat
    await Hive.openBox('chats');
    print('✅ Box chats ouverte');
    
    await ChatStorage.init();
    print('✅ ChatStorage initialisé');
    
    print('🎉 Initialisation Hive terminée avec succès!');
    
    // TEST: Vérifier que notification_settings fonctionne
    final testBox = Hive.box<NotificationSettings>('notification_settings');
    print('🧪 Test de la box notification_settings:');
    print('   Box ouverte: ${testBox.isOpen}');
    print('   Nombre d\'éléments: ${testBox.length}');
    
  } catch (e, stack) {
    print('❌ ERREUR CRITIQUE lors de l\'ouverture des boxes:');
    print('Erreur: $e');
    print('Stack trace:');
    print(stack);
    
    runApp(ErrorApp(error: e.toString()));
    return;
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const EasyTravelApp(),
    ),
  );
}

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    HomeScreen(),
    const FavoritesScreen(),
    BookingScreen(),
    const ProfileScreen(),
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