// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_geopoint_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppGeoPointAdapter extends TypeAdapter<AppGeoPoint> {
  @override
  final int typeId = 0;

  @override
  AppGeoPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppGeoPoint(
      longitude: fields[1] as double,
      latitude: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AppGeoPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppGeoPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
