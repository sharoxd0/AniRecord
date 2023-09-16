import 'package:anirecord/domain/entities/serie_info_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetSerieByIdUserCase{
  final SerieRepositoryInterface repositoryInterface;
  GetSerieByIdUserCase(this.repositoryInterface);
  
  Future<SerieInfo> call(String id) async=> await repositoryInterface.getSerieById(id);
}