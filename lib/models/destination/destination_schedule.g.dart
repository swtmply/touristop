// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DestinationScheduleAdapter extends TypeAdapter<DestinationSchedule> {
  @override
  final int typeId = 2;

  @override
  DestinationSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DestinationSchedule(
      date: fields[0] as String,
      timeOpen: fields[1] as String,
      timeClose: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DestinationSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.timeOpen)
      ..writeByte(2)
      ..write(obj.timeClose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
