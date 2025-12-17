import 'package:hive/hive.dart';

part 'notification_settings.g.dart';

@HiveType(typeId: 6) // GARDER typeId: 6 (cohérent avec main.dart)
class NotificationSettings extends HiveObject {
  @HiveField(0)
  bool reservationNotifications;

  @HiveField(1)
  bool promotionNotifications;

  @HiveField(2)
  bool newsletter;

  @HiveField(3)
  bool messageNotifications;

  @HiveField(4)
  bool pushNotifications;

  @HiveField(5)
  bool emailNotifications;

  @HiveField(6)
  bool smsNotifications;

  @HiveField(7)
  bool soundEnabled;

  @HiveField(8)
  bool vibrationEnabled;

  @HiveField(9)
  bool silentHoursEnabled;

  NotificationSettings({
    required this.reservationNotifications,
    required this.promotionNotifications,
    required this.newsletter,
    required this.messageNotifications,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.silentHoursEnabled,
  });

  // Ajouter une méthode copyWith pour faciliter les mises à jour
  NotificationSettings copyWith({
    bool? reservationNotifications,
    bool? promotionNotifications,
    bool? newsletter,
    bool? messageNotifications,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? silentHoursEnabled,
  }) {
    return NotificationSettings(
      reservationNotifications: reservationNotifications ?? this.reservationNotifications,
      promotionNotifications: promotionNotifications ?? this.promotionNotifications,
      newsletter: newsletter ?? this.newsletter,
      messageNotifications: messageNotifications ?? this.messageNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      silentHoursEnabled: silentHoursEnabled ?? this.silentHoursEnabled,
    );
  }
}