import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';
import '../../models/preferences.dart';
import '../../models/security_settings.dart';
import '../../models/notification_settings.dart';
import '../../services/default_profile_service.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/animated_logo.dart';
import '../../widgets/feature_chip.dart';
import '../../main.dart'; // Pour accéder à MainScreen (si nécessaire)

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();

    // Vérifier si un utilisateur existe déjà
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    try {
      // Si la box est déjà ouverte via l'initialisation de Hive dans main, on peut l'utiliser.
      if (Hive.isBoxOpen('users')) {
        final userBox = Hive.box<User>('users');
        if (userBox.isNotEmpty && userBox.getAt(0) != null) {
          // Laisser l'animation visible un instant
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
            );
          }
        }
      }
    } catch (e) {
      // Ne pas bloquer l'écran d'accueil en cas d'erreur
      // debugPrint('Erreur checkExistingUser: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _navigateToHomeWithDefaultProfile() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Afficher dialogue de chargement
    LoadingDialog.show(context, message: 'Chargement de votre profil...');

    try {
      // Créer ou s'assurer de l'existence d'un utilisateur et des paramètres par défaut
      await DefaultProfileService.createDefaultUserIfNeeded();
      await DefaultProfileService.saveDefaultSettings();

      // Petite attente pour UX
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      LoadingDialog.hide(context);

      // Message de bienvenue
      _showSnackbar('Bienvenue !', isError: false);

      // Naviguer vers la page d'accueil (route nommée '/home' ou MainScreen)
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) LoadingDialog.hide(context);
      _showSnackbar('redirection...', isError: false);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFFF6B6B) : const Color(0xFF06D6A0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF5B4FE8),
              Color(0xFF857BFF),
              Color(0xFFA89FFF),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              Positioned(
                top: -100,
                right: -100,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
              ),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedLogo(
                        fadeAnimation: _fadeAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      const SizedBox(height: 40),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'Eternal Escape',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Votre voyage commence ici',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Bouton principal
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: _isLoading ? null : _navigateToHomeWithDefaultProfile,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.login_rounded, size: 26, color: Color(0xFF6C63FF)),
                                      SizedBox(width: 16),
                                      Text(
                                        'Accéder à l\'application',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF333333),
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      const SizedBox(height: 50),

                      // Features
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: const [
                            FeatureChip(icon: Icons.hotel_rounded, label: 'Hôtels'),
                            FeatureChip(icon: Icons.flight_rounded, label: 'Vols'),
                            FeatureChip(icon: Icons.directions_car_rounded, label: 'Locations'),
                            FeatureChip(icon: Icons.restaurant_rounded, label: 'Restaurants'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Profitez de toutes nos fonctionnalités avec votre profil pré-configuré',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}