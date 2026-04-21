// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropAdapter extends TypeAdapter<Crop> {
  @override
  final typeId = 0;

  @override
  Crop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Crop(
      name: fields[0] as String,
      hardiness: fields[1] as String,
      criticalTemp: (fields[2] as num).toInt(),
      pivot: fields[3] as String,
      relativeStart: (fields[4] as num).toInt(),
      relativeEnd: (fields[5] as num).toInt(),
      daysToHarvest: (fields[6] as num).toInt(),
      method: fields[7] as String,
      notes: fields[8] as String,
      isSelected: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Crop obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.hardiness)
      ..writeByte(2)
      ..write(obj.criticalTemp)
      ..writeByte(3)
      ..write(obj.pivot)
      ..writeByte(4)
      ..write(obj.relativeStart)
      ..writeByte(5)
      ..write(obj.relativeEnd)
      ..writeByte(6)
      ..write(obj.daysToHarvest)
      ..writeByte(7)
      ..write(obj.method)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
