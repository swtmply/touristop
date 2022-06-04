// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dates_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatesListAdapter extends TypeAdapter<DatesList> {
  @override
  final int typeId = 3;

  @override
  DatesList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatesList(
      dateTime: fields[0] as DateTime,
      timeRemaining: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DatesList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.timeRemaining);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatesListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
