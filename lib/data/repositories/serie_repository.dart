import 'package:anirecord/data/datasources/firebase_database_source.dart';
import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/entities/serie_info_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class SerieRepository extends SerieRepositoryInterface {
  final FirebaseDataBaseSource firebaseDataBaseSource;

  SerieRepository(this.firebaseDataBaseSource);

  @override
  Future<Map<String, List<Serie>>> getActivity() async {
    return await firebaseDataBaseSource.getActivity();
  }

  @override
  Future<SerieInfo> getSerieById(String id) async {
    return await firebaseDataBaseSource.getSerieById(id);
  }

  @override
  Future<Map<String, dynamic>> getAllAlbumsOfSerieById(
      String uid, String sid) async {
    return await firebaseDataBaseSource.getAllAlbumsOfSerieById(uid, sid);
  }
  
  @override
  Future<void> addSerieToAlbum(String uid,String aid, Serie serie, bool action) async{
    return await firebaseDataBaseSource.addSerieToAlbum( uid,aid, serie, action);
    
  }
  
  @override
  Future<List<Serie>> getSeriesList({OrderOptions? orderBy = OrderOptions.season, int? limit, String? generoBy})async {
    return await firebaseDataBaseSource.getSeriesList(generoBy: generoBy,limit: limit,orderBy: orderBy);
  }

  @override
  Future<List<Album>> getAllAlbumes(String uid) async{
    return await firebaseDataBaseSource.getAllAlbumes(uid);
  }
  
  @override
  Future<void> deleteAlbumById(String uid, String aid) async{
    return await firebaseDataBaseSource.deleteAlbumById(uid, aid);
  }
  
  @override
  Future<void> createAlbum({required String uid, required String title,required int iconCode ,String? description}) async{
    return await firebaseDataBaseSource.createAlbum(uid: uid, title: title,description: description,iconCode: iconCode);
  }
  
  @override
  Future<List<Serie>> getSeriesOfAlbum(String uid, String aid) async {
    
    return await firebaseDataBaseSource.getSeriesOfAlbum(uid, aid);
  }
  
  @override
  Future<void> deleteSerieOfAlbum(String uid, String aid, String sid)async {
    // TODO: implement deleteSerieOfAlbum
    return await firebaseDataBaseSource.deleteSerieOfAlbum(uid, aid, sid);
  }
}
