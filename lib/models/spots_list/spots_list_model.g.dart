// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spots_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpotsListAdapter extends TypeAdapter<SpotsList> {
  @override
  final int typeId = 2;

  @override
  SpotsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpotsList(
      date: fields[0] as DateTime,
      spot: fields[1] as TouristSpot,
      isDone: fields[2] == null ? false : fields[2] as bool?,
      isSelected: fields[3] == null ? false : fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SpotsList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.spot)
      ..writeByte(2)
      ..write(obj.isDone)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
