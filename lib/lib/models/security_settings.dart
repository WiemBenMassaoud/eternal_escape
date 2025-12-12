import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'security_settings.g.dart';

// IMPORTANT: typeId changé de 5 à 6 pour éviter le conflit avec NotificationSettings
@HiveType(typeId: 6)
class SecuritySettings {
  @HiveField(0)
  bool twoFactorEnabled;
  
  @HiveField(1)
  bool biometricLogin;
  
  @HiveField(2)
  bool autoLogout;
  
  @HiveField(3)
  bool showActivityStatus;
  
  @HiveField(4)
  bool soundEnabled;
  
  @HiveField(5)
  bool silentHoursEnabled;
  
  @HiveField(6)
  TimeOfDay silentHoursStart;
  
  @HiveField(7)
  TimeOfDay silentHoursEnd;

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.biometricLogin,
    required this.autoLogout,
    required this.showActivityStatus,
    required this.soundEnabled,
    required this.silentHoursEnabled,
    required this.silentHoursStart,
    required this.silentHoursEnd,
  });
}