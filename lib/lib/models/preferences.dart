import 'package:hive/hive.dart';

part 'preferences.g.dart';

@HiveType(typeId: 4)
class Preferences extends HiveObject {
  @HiveField(0)
  String language;

  @HiveField(1)
  String currency;

  @HiveField(2)
  String theme;

  @HiveField(3)
  bool locationServices;

  @HiveField(4)
  bool autoSync;

  @HiveField(5)
  String notificationFrequency;

  @HiveField(6)
  String travelClass;

  @HiveField(7)
  String seatPreference;

  @HiveField(8)
  String mealPreference;

  @HiveField(9)
  String hotelType;

  @HiveField(10)
  List<String> favoriteDestinations;

  @HiveField(11)
  String averageBudget;

  @HiveField(12)
  List<String> favoriteActivities;

  Preferences({
    required this.language,
    required this.currency,
    required this.theme,
    required this.locationServices,
    required this.autoSync,
    required this.notificationFrequency,
    required this.travelClass,
    required this.seatPreference,
    required this.mealPreference,
    required this.hotelType,
    required this.favoriteDestinations,
    required this.averageBudget,
    required this.favoriteActivities,
  });
}