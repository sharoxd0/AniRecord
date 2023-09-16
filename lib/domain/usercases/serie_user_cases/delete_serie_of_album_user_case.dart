import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class DeleteSerieOfAlbumUserCase{
  final SerieRepositoryInterface repositoryInterface;

  DeleteSerieOfAlbumUserCase(this.repositoryInterface);

  Future<void> call(String uid,String aid,String sid)async =>await repositoryInterface.deleteSerieOfAlbum(uid, aid, sid);
}