// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tourist_spot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TouristSpotAdapter extends TypeAdapter<TouristSpot> {
  @override
  final int typeId = 1;

  @override
  TouristSpot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TouristSpot(
      name: fields[0] as String,
      description: fields[1] as String,
      image: fields[2] as String,
      address: fields[3] as String,
      fee: fields[4] as String,
      position: fields[5] as AppGeoPoint?,
      type: fields[6] as String,
      dates: (fields[7] as List).cast<dynamic>(),
      averageRating: fields[8] as double?,
      distanceFromUser: fields[9] as double?,
      numberOfHours: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TouristSpot obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.fee)
      ..writeByte(5)
      ..write(obj.position)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.dates)
      ..writeByte(8)
      ..write(obj.averageRating)
      ..writeByte(9)
      ..write(obj.distanceFromUser)
      ..writeByte(10)
      ..write(obj.numberOfHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TouristSpotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
