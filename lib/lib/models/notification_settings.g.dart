// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsAdapter extends TypeAdapter<NotificationSettings> {
  @override
  final int typeId = 5;

  @override
  NotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettings(
      reservationNotifications: fields[0] as bool,
      promotionNotifications: fields[1] as bool,
      newsletter: fields[2] as bool,
      messageNotifications: fields[3] as bool,
      pushNotifications: fields[4] as bool,
      emailNotifications: fields[5] as bool,
      smsNotifications: fields[6] as bool,
      soundEnabled: fields[7] as bool,
      vibrationEnabled: fields[8] as bool,
      silentHoursEnabled: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.reservationNotifications)
      ..writeByte(1)
      ..write(obj.promotionNotifications)
      ..writeByte(2)
      ..write(obj.newsletter)
      ..writeByte(3)
      ..write(obj.messageNotifications)
      ..writeByte(4)
      ..write(obj.pushNotifications)
      ..writeByte(5)
      ..write(obj.emailNotifications)
      ..writeByte(6)
      ..write(obj.smsNotifications)
      ..writeByte(7)
      ..write(obj.soundEnabled)
      ..writeByte(8)
      ..write(obj.vibrationEnabled)
      ..writeByte(9)
      ..write(obj.silentHoursEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
