import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/get_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/create_album_user_case.dart';
import 'package:anirecord/presentation/views/home/list/list_builder.dart';
import 'package:anirecord/presentation/views/serie/modal_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum StatusCreateAlbum{loading,success,error,initial}

final createAlbumProvider = StateNotifierProvider.autoDispose<CreateAlbumNotifier,StatusCreateAlbum>((ref){
  final getUserUseCase = ref.watch(getUserCasePovider);
  final createAlbumUseCase = ref.watch(createAlbumProviderr);
  void updateListAlbum ()=> ref.refresh(albumProvider);
  void updateOptions() => ref.invalidate(optionsAlbumProvier);
  return CreateAlbumNotifier(createAlbumUseCase, getUserUseCase,updateListAlbum,updateOptions);
});

class CreateAlbumNotifier extends StateNotifier<StatusCreateAlbum>{
  final CreateAlbumUserCase createAlbumUseCase;
  final GetUserCase getUserUseCase;
  final void Function() albumList;
  final void Function() updateOptions;
  
  
  
  CreateAlbumNotifier(this.createAlbumUseCase,this.getUserUseCase,this.albumList,this.updateOptions):super(StatusCreateAlbum.initial);

  Future<void> createAlbum({required String title,String? description,required int iconCode,required BuildContext context})async{
    try {
      state = StatusCreateAlbum.loading;
      await createAlbumUseCase.call(uid: getUserUseCase.call()!.uid, title: title,description: description,iconCode: iconCode);
      albumList();
      updateOptions();
      state = StatusCreateAlbum.success;
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
      
    } catch (e) {
      state =StatusCreateAlbum.error;
    }
  }
}