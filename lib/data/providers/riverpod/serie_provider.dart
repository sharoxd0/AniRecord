import 'package:anirecord/data/datasources/firebase_database_source.dart';
import 'package:anirecord/data/repositories/serie_repository.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/entities/serie_info_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/add_serie_to_album_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/create_album_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/delete_album_by_id_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/delete_serie_of_album_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_activity_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_all_albums_of_serie_by_id_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_all_albums_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_serie_by_id_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_series_list_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/get_series_of_album_user_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreSourceProvider = Provider<FirebaseDataBaseSource>((ref) {
  return FirebaseDataBaseSource(FirebaseFirestore.instance);
},);

final serieRepositoryIntefaceProvider = Provider<SerieRepositoryInterface>((ref) {
  final firestore =  ref.watch(firestoreSourceProvider);
  return SerieRepository(firestore);
},);

final getActivityProvider = FutureProvider<Map<String,List<Serie>>>((ref) async{
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return GetActivityUserCase(serieRepository).call();
});

final getSerieByIdProvider = FutureProvider.family<SerieInfo,String>((ref,id) async{
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return await GetSerieByIdUserCase(serieRepository).call(id);
});

final getAllAlbumsByIdUserProvider = Provider<GetAllAlbumsOfSerieByIdUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return GetAllAlbumsOfSerieByIdUserCase(serieRepository);
},);

final addSerieToAlbumProvider = Provider<AddSerieToAlbumUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return AddSerieToAlbumUserCase(serieRepository);
});

final getSeriesListProvider = Provider<GetSeriesListUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return GetSeriesListUserCase(serieRepository);
},);

final getAllAlbumsProvider  = Provider<GetAllAlbumsUserCase>((ref){
    final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
    return GetAllAlbumsUserCase(serieRepository);
});

final deleteAlbumByIdProvider = Provider<DeleteAlbumByIdUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return DeleteAlbumByIdUserCase(serieRepository);
},);

final createAlbumProviderr = Provider<CreateAlbumUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return CreateAlbumUserCase(serieRepository);
},);

final getSeriesOfAlbumProvider = Provider<GetSerieOfAlbumUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return GetSerieOfAlbumUserCase(serieRepository);
},);

final deleteSerieOfAlbumProvider = Provider<DeleteSerieOfAlbumUserCase>((ref) {
  final serieRepository = ref.watch(serieRepositoryIntefaceProvider);
  return DeleteSerieOfAlbumUserCase(serieRepository);
},);