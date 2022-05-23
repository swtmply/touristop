// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DateAdapter extends TypeAdapter<Date> {
  @override
  final int typeId = 0;

  @override
  Date read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Date()..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Date obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
