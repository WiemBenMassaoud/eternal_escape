// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    // CORRECTION DE L'ERREUR : Conversion sécurisée pour reservationsIds
    List<int> reservationsIds = [];
    if (fields[8] != null) {
      if (fields[8] is List<int>) {
        reservationsIds = fields[8] as List<int>;
      } else if (fields[8] is List) {
        // Tente de convertir chaque élément en int
        for (var item in fields[8] as List) {
          if (item is int) {
            reservationsIds.add(item);
          } else if (item is String) {
            final parsed = int.tryParse(item);
            if (parsed != null) reservationsIds.add(parsed);
          }
        }
      }
    }
    
    return User(
      prenom: fields[0] as String,
      nom: fields[1] as String,
      email: fields[2] as String,
      telephone: fields[3] as String,
      dateNaissance: fields[4] as DateTime?,
      photoProfil: fields[5] as String,
      adresse: fields[6] as String,
      motDePasse: fields[7] as String?,
      reservationsIds: reservationsIds, // Utilise la liste convertie
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