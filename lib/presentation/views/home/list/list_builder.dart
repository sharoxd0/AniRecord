import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/list_widgets.dart';
import 'package:anirecord/presentation/views/home/list/serie_album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final albumProvider = FutureProvider<List<Album>>((ref) async {
  final g = ref.read(getAllAlbumsProvider);
  final user = ref.read(getUserCasePovider);
  return await g.call(user.call()!.uid);
});

enum StateViewList { list, cuadros }

final stateViewList = StateNotifierProvider<StateViewListNotifier, bool>(
    (ref) => StateViewListNotifier());

class StateViewListNotifier extends StateNotifier<bool> {
  StateViewListNotifier() : super(false);

  void toggleView() {
    state = !state;
  }
}

class FavoriteListV2 extends ConsumerWidget {
  const FavoriteListV2({super.key});

  void tapLong(BuildContext context, String id) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Consumer(builder: (_, ref, __) {
                    final statusAlbum = ref.watch(deleteAlbumProvider);
                    return ListTile(
                      title: const Text(
                        "Eliminar",
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      trailing: statusAlbum == StatusDeleteAlbum.loading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1,
                            )
                          : null,
                      onTap: statusAlbum == StatusDeleteAlbum.loading
                          ? null
                          : () {
                              ref
                                  .read(deleteAlbumProvider.notifier)
                                  .deleteAlbum(id, context);
                            },
                    );
                  })
                ],
              ),
            ),
          );
        });
  }

  Widget itemGrid(List<Album> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (120.0 / 110.0),
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
          ),
          itemBuilder: (context, i) {
            final album = data[i];
            return GestureDetector(
              onLongPress: () {
                tapLong(context, album.id);
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeriesOfAlbum(album: album)));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          const SizedBox(
                            height: 110,
                            child: Icon(
                              Icons.folder,
                              color: colorPrimaryInverted,
                              size: 110,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, right: 20),
                            child: album.iconCode != 57570
                                ? Icon(
                                    IconData(album.iconCode,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(album.title,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.ondemand_video,
                            size: 21,
                          ),
                          const SizedBox(width: 10),
                          Text(album.recuento.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumProvider);
    final view = ref.watch(stateViewList);
    return RefreshIndicator(
      onRefresh: ()async => await ref.refresh(albumProvider.future),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: albums.when(data: (data) {
            if (!view) {
              return data.isNotEmpty
                  ? ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 1,
                      ), // Agrega automáticamente Divider() entre los elementos
                      itemBuilder: (context, index) {
                        final album = data[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SeriesOfAlbum(album: album),
                              ),
                            );
                          },
                          onLongPress: () {
                            tapLong(context, album.id);
                          },
                          leading: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              const Icon(
                                Icons.folder,
                                color: colorPrimaryInverted,
                                size: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, right: 8),
                                child: album.iconCode != 57570
                                    ? Icon(
                                        IconData(album.iconCode,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Text(
                                    album.recuento.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ],
                          ),
                          title: Text(
                            album.title,
                            style: const TextStyle(fontSize: 15),
                          ),
                          subtitle: album.description != null
                              ? Text(album.description!)
                              : null,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No hay ninguna lista',
                        style: TextStyle(color: Colors.grey, fontSize: 19),
                      ),
                    );
            } else {
              return data.isNotEmpty
                  ? itemGrid(data)
                  : const Center(
                      child: Text(
                        'No hay ninguna lista',
                        style: TextStyle(color: Colors.grey, fontSize: 19),
                      ),
                    );
            }
          }, error: (_, __) {
            return Text(_.toString());
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }
}
