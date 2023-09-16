import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetAllAlbumsOfSerieByIdUserCase {
  final SerieRepositoryInterface repositoryInterface;

  GetAllAlbumsOfSerieByIdUserCase(this.repositoryInterface);

  Future<Map<String,dynamic>> call(String uid, String sid) async =>
      repositoryInterface.getAllAlbumsOfSerieById(uid, sid);
}
