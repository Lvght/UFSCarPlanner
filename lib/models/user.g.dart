// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 4;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..nome = fields[0] as String
      ..ira = fields[1] as String
      ..ra = fields[2] as String
      ..senha = fields[3] as String
      ..materias = (fields[4] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, String>())
          ?.toList()
      ..mat = (fields[5] as List)
          ?.map((dynamic e) => (e as List)?.cast<Materia>())
          ?.toList();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.ira)
      ..writeByte(2)
      ..write(obj.ra)
      ..writeByte(3)
      ..write(obj.senha)
      ..writeByte(4)
      ..write(obj.materias)
      ..writeByte(5)
      ..write(obj.mat);
  }
}
