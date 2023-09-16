import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/serie/serie_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final serieNewsProvider =
    FutureProvider.family<List<Serie>, String?>((ref, genere) async {
  return await ref
      .read(getSeriesListProvider)
      .call(options: OrderOptions.created, limit: 12, generosBy: genere);
});

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
  String? generoSeleccionado;
  void selectGenero(String genero) {
    setState(() {
      generoSeleccionado = genero;
    });
  }

  Widget _buildGenre(String name) {
    return GestureDetector(
      onTap: () {
        selectGenero(name);
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: name == generoSeleccionado ? colorPrimaryInverted : null,
          border: Border.all(
            color: name == generoSeleccionado
                ? colorPrimaryInverted
                : Colors.black,
          ),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            name,
            style: GoogleFonts.openSans(
                fontSize: 14,
                color:
                    name == generoSeleccionado ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  List<String> generos = ['Acción', 'Comedia', 'Drama'];
  @override
  Widget build(BuildContext context) {
    final newSeries = ref.watch(serieNewsProvider(generoSeleccionado));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: generos.map((e) {
                  final genero = e;
                  return _buildGenre(genero);
                }).toList(),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Resultados',
                  style: GoogleFonts.openSans(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              
              )),
          newSeries.when(data: (data) {
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (120.0 / 165.0),
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  final serie = data[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SerieBuilder(serie)));
                    },
                    child: Card(
                      elevation: 1,
                      margin: const EdgeInsets.all(2),
                      shape: RoundedRectangleBorder(
                        // Add this line to set the border
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                imageCover(serie.id)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }, error: (_, __) {
            return Text(__.toString());
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorPrimaryInverted,
              ),
            );
          }),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
