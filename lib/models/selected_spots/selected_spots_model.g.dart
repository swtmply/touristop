// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_spots_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedSpotsAdapter extends TypeAdapter<SelectedSpots> {
  @override
  final int typeId = 4;

  @override
  SelectedSpots read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedSpots(
      spot: fields[0] as TouristSpot,
    );
  }

  @override
  void write(BinaryWriter writer, SelectedSpots obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.spot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedSpotsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
