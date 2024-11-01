// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_recomendation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookRecomendationModelAdapter
    extends TypeAdapter<BookRecomendationModel> {
  @override
  final int typeId = 1;

  @override
  BookRecomendationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookRecomendationModel(
      title: fields[0] as String,
      author: fields[1] as String,
      description: fields[2] as String,
      pages: fields[3] as String,
      genre: fields[4] as String,
      keywords: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookRecomendationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pages)
      ..writeByte(4)
      ..write(obj.genre)
      ..writeByte(5)
      ..write(obj.keywords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookRecomendationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
