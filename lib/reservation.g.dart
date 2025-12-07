// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReservationAdapter extends TypeAdapter<Reservation> {
  @override
  final int typeId = 2;

  @override
  Reservation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reservation(
      logementId: fields[0] as int,
      dateDebut: fields[1] as DateTime,
      dateFin: fields[2] as DateTime,
      prixTotal: fields[3] as double,
      utilisateurEmail: fields[4] as String,
      statut: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reservation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.logementId)
      ..writeByte(1)
      ..write(obj.dateDebut)
      ..writeByte(2)
      ..write(obj.dateFin)
      ..writeByte(3)
      ..write(obj.prixTotal)
      ..writeByte(4)
      ..write(obj.utilisateurEmail)
      ..writeByte(5)
      ..write(obj.statut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
