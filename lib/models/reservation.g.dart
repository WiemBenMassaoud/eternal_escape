// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReservationAdapter extends TypeAdapter<Reservation> {
  @override
  final int typeId = 1;

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
      status: fields[5] as String? ?? 'pending',
      paymentMethod: fields[6] as String?,
      serviceFee: fields[7] as double?,
      cleaningFee: fields[8] as double?,
      createdAt: fields[9] as DateTime?,
      cancelledAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Reservation obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.paymentMethod)
      ..writeByte(7)
      ..write(obj.serviceFee)
      ..writeByte(8)
      ..write(obj.cleaningFee)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.cancelledAt);
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