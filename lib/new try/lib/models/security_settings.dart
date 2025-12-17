import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'security_settings.g.dart';

@HiveType(typeId: 5)
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
  int silentHoursStartHour;  // Stocké comme int
  
  @HiveField(7)
  int silentHoursStartMinute;  // Stocké comme int
  
  @HiveField(8)
  int silentHoursEndHour;  // Stocké comme int
  
  @HiveField(9)
  int silentHoursEndMinute;  // Stocké comme int

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.biometricLogin,
    required this.autoLogout,
    required this.showActivityStatus,
    required this.soundEnabled,
    required this.silentHoursEnabled,
    required TimeOfDay silentHoursStart,
    required TimeOfDay silentHoursEnd,
  }) : silentHoursStartHour = silentHoursStart.hour,
       silentHoursStartMinute = silentHoursStart.minute,
       silentHoursEndHour = silentHoursEnd.hour,
       silentHoursEndMinute = silentHoursEnd.minute;

  TimeOfDay get silentHoursStart => TimeOfDay(
    hour: silentHoursStartHour,
    minute: silentHoursStartMinute,
  );

  TimeOfDay get silentHoursEnd => TimeOfDay(
    hour: silentHoursEndHour,
    minute: silentHoursEndMinute,
  );
}