import 'package:anirecord/domain/repositories/serie_repository_interface.dart';

class CreateAlbumUserCase{
  final SerieRepositoryInterface repositoryInterface;

  CreateAlbumUserCase(this.repositoryInterface);

  Future<void> call({required String uid,required String title,required int iconCode,String? description}) async => await repositoryInterface.createAlbum(uid: uid, title: title,description: description,iconCode: iconCode);

}