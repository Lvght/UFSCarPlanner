// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MateriaAdapter extends TypeAdapter<Materia> {
  @override
  final typeId = 3;

  @override
  Materia read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Materia.internal()
      ..codigo = fields[0] as String
      ..nome = fields[1] as String
      ..dia = fields[2] as String
      ..horaI = fields[3] as String
      ..horaF = fields[4] as String
      ..turma = fields[5] as String
      ..ministrantes = fields[6] as String
      ..local = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, Materia obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.codigo)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.dia)
      ..writeByte(3)
      ..write(obj.horaI)
      ..writeByte(4)
      ..write(obj.horaF)
      ..writeByte(5)
      ..write(obj.turma)
      ..writeByte(6)
      ..write(obj.ministrantes)
      ..writeByte(7)
      ..write(obj.local);
  }
}
