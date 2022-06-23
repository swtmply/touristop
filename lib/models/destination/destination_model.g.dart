// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DestinationAdapter extends TypeAdapter<Destination> {
  @override
  final int typeId = 0;

  @override
  Destination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Destination(
      name: fields[0] as String,
      description: fields[1] as String,
      address: fields[2] as String,
      fee: fields[3] as String,
      guideline: fields[4] as String,
      type: fields[5] as String,
      numberOfHours: fields[6] as double,
      images: (fields[7] as List).cast<String>(),
      position: fields[8] as DestinationPosition,
      schedule: (fields[9] as List).cast<DestinationSchedule>(),
      rating: fields[10] as double?,
      distance: fields[11] as double?,
      id: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Destination obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.fee)
      ..writeByte(4)
      ..write(obj.guideline)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.numberOfHours)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.position)
      ..writeByte(9)
      ..write(obj.schedule)
      ..writeByte(10)
      ..write(obj.rating)
      ..writeByte(11)
      ..write(obj.distance)
      ..writeByte(12)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
