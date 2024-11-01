// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_recomendation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieRecomendationModelAdapter
    extends TypeAdapter<MovieRecomendationModel> {
  @override
  final int typeId = 0;

  @override
  MovieRecomendationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieRecomendationModel(
      title: fields[0] as String,
      director: fields[1] as String,
      description: fields[2] as String,
      posterUrl: fields[3] as String,
      imdbRating: fields[4] as String,
      actors: (fields[5] as List).cast<String>(),
      genre: fields[6] as String,
      year: fields[7] as String,
      duration: fields[8] as String,
      keywords: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieRecomendationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.director)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(4)
      ..write(obj.imdbRating)
      ..writeByte(5)
      ..write(obj.actors)
      ..writeByte(6)
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.year)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.keywords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieRecomendationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
