import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetSeriesListUserCase{
  final SerieRepositoryInterface repositoryInterface;

  GetSeriesListUserCase(this.repositoryInterface);

  Future<List<Serie>> call({OrderOptions? options=OrderOptions.season,int?limit,String? generosBy}) async => await repositoryInterface
  .getSeriesList(orderBy: options,limit: limit,generoBy: generosBy);
}