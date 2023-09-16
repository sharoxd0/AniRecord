import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/entities/serie_info_entity.dart';

enum OrderOptions { season, year, created }

abstract class SerieRepositoryInterface {
  //Obtener todos las nuevas series que se estan agregando
  Future<Map<String, List<Serie>>> getActivity();
  //Se obtine los detalles de una serie en especifico
  Future<SerieInfo> getSerieById(String id);

  //Se obiene todos los albumes del usuario
  Future<Map<String, dynamic>> getAllAlbumsOfSerieById(String uid, String sid);
  //Actualizar el album con las nuevas series que se agregaron o elimianron
  Future<void> addSerieToAlbum(
      String uid, String aid, Serie serie, bool action);

  Future<List<Serie>> getSeriesList(
      {OrderOptions? orderBy = OrderOptions.season,
      int? limit,
      String? generoBy});

  Future<List<Album>> getAllAlbumes(String uid);
  Future<void> deleteAlbumById(String uid, String aid);
  Future<void> deleteSerieOfAlbum(String uid,String aid,String sid);
  Future<void> createAlbum(
      {required String uid, required String title, String? description,required int iconCode});
      Future<List<Serie>> getSeriesOfAlbum(String uid,String aid);
}
