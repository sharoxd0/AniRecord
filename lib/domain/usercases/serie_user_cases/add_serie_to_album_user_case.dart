import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class AddSerieToAlbumUserCase {
  final SerieRepositoryInterface repositoryInterface;

  AddSerieToAlbumUserCase(this.repositoryInterface);

  Future<void> call(
          String uid, String aid, Serie serie, bool action) async =>
      await repositoryInterface.addSerieToAlbum(uid, aid, serie, action);
}
