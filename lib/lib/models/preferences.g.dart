// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferencesAdapter extends TypeAdapter<Preferences> {
  @override
  final int typeId = 4;

  @override
  Preferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preferences(
      language: fields[0] as String,
      currency: fields[1] as String,
      theme: fields[2] as String,
      locationServices: fields[3] as bool,
      autoSync: fields[4] as bool,
      notificationFrequency: fields[5] as String,
      travelClass: fields[6] as String,
      seatPreference: fields[7] as String,
      mealPreference: fields[8] as String,
      hotelType: fields[9] as String,
      favoriteDestinations: (fields[10] as List).cast<String>(),
      averageBudget: fields[11] as String,
      favoriteActivities: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Preferences obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.theme)
      ..writeByte(3)
      ..write(obj.locationServices)
      ..writeByte(4)
      ..write(obj.autoSync)
      ..writeByte(5)
      ..write(obj.notificationFrequency)
      ..writeByte(6)
      ..write(obj.travelClass)
      ..writeByte(7)
      ..write(obj.seatPreference)
      ..writeByte(8)
      ..write(obj.mealPreference)
      ..writeByte(9)
      ..write(obj.hotelType)
      ..writeByte(10)
      ..write(obj.favoriteDestinations)
      ..writeByte(11)
      ..write(obj.averageBudget)
      ..writeByte(12)
      ..write(obj.favoriteActivities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
