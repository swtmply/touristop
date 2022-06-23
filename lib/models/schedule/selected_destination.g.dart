// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_destination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedDestinationAdapter extends TypeAdapter<SelectedDestination> {
  @override
  final int typeId = 4;

  @override
  SelectedDestination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedDestination(
      dateSelected: fields[0] as DateTime,
      destination: fields[1] as Destination,
      isDone: fields[2] == null ? false : fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SelectedDestination obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateSelected)
      ..writeByte(1)
      ..write(obj.destination)
      ..writeByte(2)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedDestinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
