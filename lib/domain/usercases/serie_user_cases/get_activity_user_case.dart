import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class GetActivityUserCase{
  final SerieRepositoryInterface repositoryInterface;

  GetActivityUserCase(this.repositoryInterface);

  Future<Map<String,List<Serie>>> call()async => await repositoryInterface.getActivity();

}