// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      prenom: fields[0] as String,
      nom: fields[1] as String,
      email: fields[2] as String,
      telephone: fields[3] as String,
      dateNaissance: fields[4] as DateTime?,
      photoProfil: fields[5] as String?,
      adresse: fields[6] as String?,
      motDePasse: fields[7] as String?,
      reservationsIds: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.prenom)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.telephone)
      ..writeByte(4)
      ..write(obj.dateNaissance)
      ..writeByte(5)
      ..write(obj.photoProfil)
      ..writeByte(6)
      ..write(obj.adresse)
      ..writeByte(7)
      ..write(obj.motDePasse)
      ..writeByte(8)
      ..write(obj.reservationsIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
