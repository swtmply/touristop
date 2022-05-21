// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spots_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpotBoxAdapter extends TypeAdapter<SpotBox> {
  @override
  final int typeId = 0;

  @override
  SpotBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpotBox()
      ..touristSpot = fields[0] as TouristSpot
      ..dateSelected = fields[1] as DateTime
      ..isDone = fields[2] == null ? false : fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, SpotBox obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.touristSpot)
      ..writeByte(1)
      ..write(obj.dateSelected)
      ..writeByte(2)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
