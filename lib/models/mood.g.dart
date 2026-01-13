// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodAdapter extends TypeAdapter<Mood> {
  @override
  final int typeId = 1;

  @override
  Mood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mood.terrible;
      case 1:
        return Mood.bad;
      case 2:
        return Mood.okay;
      case 3:
        return Mood.good;
      case 4:
        return Mood.amazing;
      default:
        return Mood.terrible;
    }
  }

  @override
  void write(BinaryWriter writer, Mood obj) {
    switch (obj) {
      case Mood.terrible:
        writer.writeByte(0);
        break;
      case Mood.bad:
        writer.writeByte(1);
        break;
      case Mood.okay:
        writer.writeByte(2);
        break;
      case Mood.good:
        writer.writeByte(3);
        break;
      case Mood.amazing:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
