import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/new_album_modal.dart';
import 'package:anirecord/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNewListScreen extends StatefulWidget {
  const CreateNewListScreen({super.key});

  @override
  State<CreateNewListScreen> createState() => _CreateNewListScreenState();
}

class _CreateNewListScreenState extends State<CreateNewListScreen> {
  String inputValue = '';
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeDescription = FocusNode();
  bool isFocused = false;
  bool isFocusedDescription = false;
  TextEditingController nameList = TextEditingController();
  TextEditingController description = TextEditingController();
  late IconData selectedIcon;

   final List<IconData> icons = [
    Icons.movie,
    Icons.favorite,
    Icons.star,
    Icons.thumb_up,
    Icons.visibility,
    Icons.task_alt,
    Icons.highlight_off,
    Icons.watch_later,
    Icons.help,
    Icons.block_flipped,
    
    Icons.bookmark,
    
  ];

  @override
  void initState() {
    super.initState();
    selectedIcon= icons[9];
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
    focusNodeDescription.addListener(() {
      setState(() {
        isFocusedDescription = focusNodeDescription.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    nameList.dispose();
    description.dispose();
    super.dispose();
  }

  Widget statusIcon(StatusCreateAlbum status,BuildContext context) {
    if (status == StatusCreateAlbum.initial) {
      return const Icon(Icons.arrow_forward_ios);
    } else if (status == StatusCreateAlbum.loading) {
      return const Padding(
        padding:  EdgeInsets.all(12.0),
        child:  CircularProgressIndicator(color: Colors.white,strokeWidth: 1,),
      );
    } else if(status== StatusCreateAlbum.success){
     return const Icon(Icons.arrow_forward_ios);
    }else{
      return const Icon(Icons.arrow_forward_ios);
    }
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Consumer(builder: (_, ref, __) {
                    final createAlbum = ref.watch(createAlbumProvider);
                    return FloatingActionButton(
                      backgroundColor: colorPrimaryInverted,
                        onPressed: createAlbum != StatusCreateAlbum.loading
                            ? () {
                                ref
                                    .read(createAlbumProvider.notifier)
                                    .createAlbum(
                                      iconCode: selectedIcon.codePoint,
                                        title: nameList.text,
                                        description: description.text == ""
                                            ? null
                                            : description.text,context: context);
                              }
                            : null,
                        child: statusIcon(createAlbum,context));
                  }),
      appBar: AppBar(
        backgroundColor: colorAppBar,
        elevation: 0,
        title: const Text(
                      "Crear nueva lista",
                      style: TextStyle( fontSize: 18,color: Colors.black),
                    ),
        leading: IconButton(onPressed: (){
          router.pop();
        }, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
      ),
      body:  SizedBox(
      height: 350,
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameList,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: isFocused ? Colors.blue : Colors.black,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.black), // Set the border color to white
                      ),
                      label: const Text(
                        "Nombre de la lista",
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextField(
                      controller: description,
                      focusNode: focusNodeDescription,
                      
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: isFocusedDescription
                              ? Colors.blue
                              : Colors.black,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .black), // Set the border color to white
                        ),
                        label: const Text(
                          "Descripción (Opcional)",
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),                
                ],
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: GridView.builder(
                      itemCount: icons.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 5,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                       itemBuilder: (context,i){
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIcon = icons[i];
                // print(selectedIcon.codePoint);
                
              });
            },
            child: Icon(icons[i], size: 48.0, color: selectedIcon == icons[i]
                  ? colorPrimaryInverted
                  : Colors.grey,));
                       }),
              )
  
            ],
          )),
    )
  ,
    );
  }
}
