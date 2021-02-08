// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterventionScheduleAdapter extends TypeAdapter<InterventionSchedule> {
  @override
  final int typeId = 204;

  @override
  InterventionSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InterventionSchedule(
      frequency: fields[0] as int,
      timestamps: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, InterventionSchedule obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.frequency)
      ..writeByte(1)
      ..write(obj.timestamps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterventionScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
