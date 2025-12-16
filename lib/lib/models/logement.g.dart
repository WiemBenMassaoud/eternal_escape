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
      id: fields[0] as int?,
      nom: fields[1] as String,
      ville: fields[2] as String,
      prix: fields[3] as double,
      description: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      adresse: fields[6] as String,
      nombreChambres: fields[7] as int,
      nombreSallesBain: fields[8] as int,
      note: fields[9] as double,
      type: fields[10] as String,
      pensionType: fields[11] as String?,
      nombreChambresDisponibles: fields[12] as int?,
      hasSuites: fields[13] as bool?,
      prixSuite: fields[14] as double?,
      nombreEtoiles: fields[15] as int,
      nombreAvis: fields[16] as int,
      equippements: (fields[17] as List?)?.cast<String>(),
      hasWiFi: fields[18] as bool,
      hasParking: fields[19] as bool,
      hasPool: fields[20] as bool,
      avis: (fields[21] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Logement obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.ville)
      ..writeByte(3)
      ..write(obj.prix)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.adresse)
      ..writeByte(7)
      ..write(obj.nombreChambres)
      ..writeByte(8)
      ..write(obj.nombreSallesBain)
      ..writeByte(9)
      ..write(obj.note)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.pensionType)
      ..writeByte(12)
      ..write(obj.nombreChambresDisponibles)
      ..writeByte(13)
      ..write(obj.hasSuites)
      ..writeByte(14)
      ..write(obj.prixSuite)
      ..writeByte(15)
      ..write(obj.nombreEtoiles)
      ..writeByte(16)
      ..write(obj.nombreAvis)
      ..writeByte(17)
      ..write(obj.equippements)
      ..writeByte(18)
      ..write(obj.hasWiFi)
      ..writeByte(19)
      ..write(obj.hasParking)
      ..writeByte(20)
      ..write(obj.hasPool)
      ..writeByte(21)
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
