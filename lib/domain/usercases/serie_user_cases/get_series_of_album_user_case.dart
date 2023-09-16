
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetSerieOfAlbumUserCase {
  final SerieRepositoryInterface _serieRepository;

  GetSerieOfAlbumUserCase(this._serieRepository);

  Future<List<Serie>> call(String uid,String aid) async => await _serieRepository.getSeriesOfAlbum(uid, aid);

}