// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecuritySettingsAdapter extends TypeAdapter<SecuritySettings> {
  @override
  final int typeId = 6;

  @override
  SecuritySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecuritySettings(
      twoFactorEnabled: fields[0] as bool,
      biometricLogin: fields[1] as bool,
      autoLogout: fields[2] as bool,
      showActivityStatus: fields[3] as bool,
      soundEnabled: fields[4] as bool,
      silentHoursEnabled: fields[5] as bool,
      silentHoursStart: fields[6] as TimeOfDay,
      silentHoursEnd: fields[7] as TimeOfDay,
    );
  }

  @override
  void write(BinaryWriter writer, SecuritySettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.twoFactorEnabled)
      ..writeByte(1)
      ..write(obj.biometricLogin)
      ..writeByte(2)
      ..write(obj.autoLogout)
      ..writeByte(3)
      ..write(obj.showActivityStatus)
      ..writeByte(4)
      ..write(obj.soundEnabled)
      ..writeByte(5)
      ..write(obj.silentHoursEnabled)
      ..writeByte(6)
      ..write(obj.silentHoursStart)
      ..writeByte(7)
      ..write(obj.silentHoursEnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecuritySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
