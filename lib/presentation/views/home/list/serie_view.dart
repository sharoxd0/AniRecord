import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/serie_album.dart';
import 'package:anirecord/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SerieOfAlbumView extends StatefulWidget {
  const SerieOfAlbumView({required this.series, required this.album,super.key});
  final Album album;
  final List<Serie> series;

  @override
  State<SerieOfAlbumView> createState() => _SerieOfAlbumViewState();
}

class _SerieOfAlbumViewState extends State<SerieOfAlbumView> {

  @override
  Widget build(BuildContext context) {
    return ExpandableList(series: widget.series,albumId:widget.album);
  }
}

// stores ExpansionPanel state information

class ExpandableList extends StatefulWidget {
  final List<Serie> series;
  final Album albumId;

  const ExpandableList({super.key, required this.series,required this.albumId});
  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  List<bool> _isOpen = [];

  @override
  void initState() {
    _isOpen = List.generate(widget.series.length, (index) => false);
    super.initState();
  }

  void _handleTap(int index) {
    setState(() {
      for (int i = 0; i < _isOpen.length; i++) {
        if (i == index) {
          _isOpen[i] = !_isOpen[i];
        } else {
          _isOpen[i] = false;
        }
      }
    });
  }

  Widget _buildExpandedContent(int index) {
    double size = 30;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.star_border_outlined,
            size: size,
          ),
          onPressed: () {
            // Acción cuando se presiona el primer IconButton
          },
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            size: size,
          ),
          onPressed: () {
            router.push('/serie', extra: widget.series[index]);
          },
        ),
        Consumer(
          builder: (context,ref,_) {
            return IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: size,
              ),
              onPressed: () {
                final user = ref.read(getUserCasePovider).call();
                ref.read(deleteSerieOfAlbumProvider).call(user!.uid, widget.albumId.id,widget.series[index].id);
                        ref.invalidate(seriesOfAlbumFuture(widget.albumId));

              },
            );
          }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.series.length,
        itemBuilder: (context, index) {
          final serie = widget.series[index];
          final isSelected = _isOpen[index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200), // Duración de la animación
            padding: isSelected
                ? const EdgeInsets.all(16)
                : const EdgeInsets.only(top: 8, right: 8),
            child: InkWell(
              onTap: () {
                _handleTap(index);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffc8c8c8).withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: ListTile(
                            leading: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: colorPrimaryInverted,
                              ),
                            ),
                            minLeadingWidth: 30,
                            horizontalTitleGap: 12,
                            title: Text(
                              serie.name,
                              style: TextStyle(
                                  height: 1.4,
                                  fontSize: 14,
                                  color:
                                      isSelected ? colorPrimaryInverted : null),
                            ),
                            subtitle: Text(
                              serie.studio,
                              style: const TextStyle(
                                color: Colors.grey,
                                height: 1.4,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Hero(
                            tag: 'image_${widget.series[index].id}',
                            child: CachedNetworkImage(
                              imageUrl: imageCover(serie.id),
                              imageBuilder: (BuildContext context,
                                  ImageProvider imageProvider) {
                                return Container(
                                  width: 40.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _isOpen[index] ? 50 : 0,
                      child: _isOpen[index]
                          ? Center(child: _buildExpandedContent(index))
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
