import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/serie/modal_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SerieOfLists extends StatelessWidget {
  const SerieOfLists({super.key, required this.serie});
  final Serie serie;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,_) {
        final option = ref.read(optionStateProvider(serie.id).notifier);
        return WillPopScope(
          onWillPop: ()async{
            option.back();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              backgroundColor: colorPrimaryInverted,
              onPressed: (){
                option.save(serie);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lista actualizada")));


            },child: const Icon(Icons.check),),
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
                option.back();
              }, icon:const  Icon(Icons.arrow_back_ios,color: Colors.black,)),
              title:const Text("Guardar en una lista",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400),),
              backgroundColor: colorAppBar,
            ),
            body: ModalOptionsFlow(serie:serie)
          ),
        );
      }
    );
  }
}