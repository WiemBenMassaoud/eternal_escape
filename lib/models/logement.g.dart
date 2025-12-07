// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogementAdapter extends TypeAdapter<Logement> {
  @override
  final int typeId = 1;

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
    );
  }

  @override
  void write(BinaryWriter writer, Logement obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.type);
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
