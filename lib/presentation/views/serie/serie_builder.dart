import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/serie/serie_description.dart';
import 'package:anirecord/presentation/views/serie/serie_of_list.dart';
import 'package:anirecord/presentation/views/serie/serie_widgets.dart';
import 'package:anirecord/router.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final isShowProvider = FutureProvider.autoDispose<bool>((ref) async{
  await Future.delayed(const Duration(milliseconds: 500));
  return true;
});

class SerieBuilder extends ConsumerWidget {
  const SerieBuilder(this.serie, {super.key});
  final Serie serie;

Widget _title(bool value){
  return  Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Color(0xff151827)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 5, bottom: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: AutoSizeText(
                                      serie.name,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                  ),
                                  Text(
                                    "${serie.year} · ${serie.studio}",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )
                                ],
                              )),
                        ),
                        const Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
             
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final details = ref.watch(getSerieByIdProvider(serie.id));
    final isShow = ref.watch(isShowProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimaryInverted,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SerieOfLists(serie: serie)));
        },
        child: const Icon(Icons.bookmark_add),
      ),
      appBar: AppBar(
        actions: [
          Container(
            child: Text('  '),
          )
        ],
        title: AutoSizeText(
          serie.name,
          maxLines: 1,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              router.pop();
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height * 0.63,
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    15.0), // Ajusta el radio según tu preferencia
              ),
              child: Hero(
                tag: 'image_${serie.id}',
                child: CachedNetworkImage(
                  imageUrl: imageCover(serie.id),
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          // shadow(height),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.52,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: AutoSizeText(serie.generos.join(", "),
              //       maxLines: 2,
              //       style: GoogleFonts.openSans(
              //           fontSize: 16, fontWeight: FontWeight.bold)),
              // ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isShow.asData?.value?? false ? 1:0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Color(0xff151827)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: AutoSizeText(
                                        serie.name,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19),
                                      ),
                                    ),
                                    Text(
                                      "${serie.year} · ${serie.studio}",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                )),
                          ),
                          const Expanded(
                              flex: 2,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      
              const SizedBox(
                height: 20,
              ),
              details.when(data: (data) {
                return ShowUp(
                    delay: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, createRoute(data.description));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data.description,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(fontSize: 14),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, left: 24),
                          child: infoWidget(
                              serie.season, serie.year, serie.status),
                        ),
                      ],
                    ));
              }, error: (error, _) {
                return Text(error.toString());
              }, loading: () {
                return Container();
              })
            ],
          ),
        ],
      ),
    );
  }
}
