import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class SeriePortable {
  final String id;
  final String name;
  final String studio;
  final int year;

  SeriePortable(this.id, this.name, this.studio, this.year);
  
  factory SeriePortable.fromMap(QueryDocumentSnapshot map) {
    final data = map.data() as Map<String, dynamic>;

    return SeriePortable(
      map.id,
      data['title'],
      data['studio'],
      data['year']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'studio': studio,
      'year': year,
    };
  }
}


class Serie extends Equatable {
  final String id;
  final String name;
  final int year;
  final String season;
  final DateTime created;
  final int count;
  final bool? isFavorite;
  final String studio;
  final String status;
  final List<String> generos;

  const Serie(
      {required this.id,
      required this.name,
      required this.year,
      required this.season,
      required this.created,
      required this.count,
      required this.generos,
      required this.status,
      required this.studio,
      this.isFavorite});

  @override
  List<Object> get props => [id, name, year, season,studio,generos,created,status];

  factory Serie.fromMap(Map<String, dynamic> map, String id) {
    List<dynamic> generos = map['generos'];
    List<String> generosComoStrings =
        generos.map((genero) => genero.toString()).toList();
    return Serie(
        id: id,
        name: map['name'],
        year: map['year'] as int,
        created: map['created'].toDate(),
        season: map['season'],
        generos: generosComoStrings,
        status: map['status'],
        studio: map['studio'],
        count: map["count"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'year': year,
      'season': season,
      'created': created,
      'generos': generos,
      'count': count,
      'status':status,
      'studio':studio
    };
  }

  Serie copyWith(
      {String? id,
      String? name,
      int? year,
      String? season,
      bool? isFavorite,
      DateTime? created,
      List<String>? generos,
      String? studio,
      String? status,
      int? count}) {
    return Serie(
        id: id ?? this.id,
        name: name ?? this.name,
        year: year ?? this.year,
        season: season ?? this.season,
        isFavorite: isFavorite ?? this.isFavorite,
        created: created ?? this.created,
        generos: generos ?? this.generos,
        count: count ?? this.count,
        studio: studio??this.studio,
        status: status??this.status
    );
  }
}
