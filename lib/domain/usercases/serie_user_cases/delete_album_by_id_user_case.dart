import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class DeleteAlbumByIdUserCase {
  final SerieRepositoryInterface repositoryInterface;

  DeleteAlbumByIdUserCase(this.repositoryInterface);

  Future<void> call(String uid,String aid)async => await repositoryInterface.deleteAlbumById(uid, aid);

}