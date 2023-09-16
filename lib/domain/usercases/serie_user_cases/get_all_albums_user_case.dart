import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetAllAlbumsUserCase{
  final SerieRepositoryInterface repositoryInterface;

  GetAllAlbumsUserCase(this.repositoryInterface);

  Future<List<Album>> call(String uid) async => await repositoryInterface.getAllAlbumes(uid);

}