import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/get_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/delete_album_by_id_user_case.dart';
import 'package:anirecord/presentation/views/home/list/list_builder.dart';
import 'package:anirecord/presentation/views/serie/modal_options.dart';
import 'package:anirecord/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StatusDeleteAlbum {loading,success, error,initial}

final deleteAlbumProvider = StateNotifierProvider.autoDispose<DeleteAlbumNotifier,StatusDeleteAlbum>((ref) {

  final getUserUseCaseP = ref.watch(getUserCasePovider);
  final deleteALbumByIdP =ref.watch(deleteAlbumByIdProvider);
  void onUpdateAlnum ()=> ref.invalidate(albumProvider);
  void updateOptions() => ref.invalidate(optionsAlbumProvier);
  return DeleteAlbumNotifier(deleteALbumByIdP,getUserUseCaseP,onUpdateAlnum,updateOptions);
});


class DeleteAlbumNotifier extends StateNotifier<StatusDeleteAlbum>{
  final GetUserCase getUserUseCase;
  final DeleteAlbumByIdUserCase deleteAlbumById;
  final void Function() onUpdatelist;
  final void Function() updateOptions;
  DeleteAlbumNotifier(this.deleteAlbumById,this.getUserUseCase,this.onUpdatelist,this.updateOptions):super(StatusDeleteAlbum.initial);

  Future<void> deleteAlbum(String aid,BuildContext context)async {
    try {
      state = StatusDeleteAlbum.loading;
      await deleteAlbumById.call(getUserUseCase.call()!.uid, aid);
      await Future.delayed(const Duration(seconds: 1));
      onUpdatelist();
      updateOptions();
      state = StatusDeleteAlbum.success;
      router.pop();
    } catch (e) {
      state=StatusDeleteAlbum.error;
    }
  }

}