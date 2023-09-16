import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/serie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seriesOfAlbumFuture =
    FutureProvider.family<List<Serie>, Album>((ref, album) async {
  final getSeriesOfAlbum = ref.watch(getSeriesOfAlbumProvider);
  final user = ref.watch(getUserCasePovider);
  return getSeriesOfAlbum.call(user.call()!.uid, album.id);
});

class SeriesOfAlbum extends ConsumerWidget {
  const SeriesOfAlbum({required this.album, super.key});
  final Album album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(seriesOfAlbumFuture(album));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          backgroundColor: colorAppBar,
          title: Text(
            album.title,
            style: const TextStyle(color: Colors.black),
          )),
      body: RefreshIndicator(child: series.when(data: (data) {
        return data.isNotEmpty? SerieOfAlbumView(
          series: data,
          album: album,
        ):const Center(child: Text("No hay ningun elemento"),);
      }, error: (_, __) {
        return Container();
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }), onRefresh: ()async{
        await Future.delayed(const Duration(seconds: 1));
        ref.invalidate(seriesOfAlbumFuture(album));
      })
    );
  }
}
