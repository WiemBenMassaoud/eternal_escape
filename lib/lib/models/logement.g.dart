// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogementAdapter extends TypeAdapter<Logement> {
  @override
  final int typeId = 0;

  @override
  Logement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Logement(
      nom: fields[0] as String,
      ville: fields[1] as String,
      prix: fields[2] as double,
      description: fields[3] as String,
      images: (fields[4] as List).cast<String>(),
      adresse: fields[5] as String,
      nombreChambres: fields[6] as int,
      nombreSallesBain: fields[7] as int,
      note: fields[8] as double,
      type: fields[9] as String,
      pensionType: fields[10] as String?,
      nombreChambresDisponibles: fields[11] as int?,
      hasSuites: fields[12] as bool?,
      prixSuite: fields[13] as double?,
      nombreEtoiles: fields[14] as int,
      nombreAvis: fields[15] as int,
      equippements: (fields[16] as List?)?.cast<String>(),
      hasWiFi: fields[17] as bool,
      hasParking: fields[18] as bool,
      hasPool: fields[19] as bool,
      avis: (fields[20] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Logement obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.nom)
      ..writeByte(1)
      ..write(obj.ville)
      ..writeByte(2)
      ..write(obj.prix)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.images)
      ..writeByte(5)
      ..write(obj.adresse)
      ..writeByte(6)
      ..write(obj.nombreChambres)
      ..writeByte(7)
      ..write(obj.nombreSallesBain)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.pensionType)
      ..writeByte(11)
      ..write(obj.nombreChambresDisponibles)
      ..writeByte(12)
      ..write(obj.hasSuites)
      ..writeByte(13)
      ..write(obj.prixSuite)
      ..writeByte(14)
      ..write(obj.nombreEtoiles)
      ..writeByte(15)
      ..write(obj.nombreAvis)
      ..writeByte(16)
      ..write(obj.equippements)
      ..writeByte(17)
      ..write(obj.hasWiFi)
      ..writeByte(18)
      ..write(obj.hasParking)
      ..writeByte(19)
      ..write(obj.hasPool)
      ..writeByte(20)
      ..write(obj.avis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
