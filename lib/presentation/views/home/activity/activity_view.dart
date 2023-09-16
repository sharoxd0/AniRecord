
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/activity/activity_widgets.dart';
import 'package:anirecord/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ActivityView extends StatelessWidget {
  final Map<String,List<Serie>> data;
  const ActivityView({super.key,required this.data});
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          divider(),
          SingleChildScrollView(
            child: Column(
                children: data.entries.map((e) {
              return Column(children: [
                pointSecction(e.key),
                const SizedBox(
                  height: 5,
                ),
                secction(e.value.length),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 40,
                              ),
                              SizedBox(
                                height: 220,
                                child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: e.value.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: (40.0 / 28.0),
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                    ),
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          router.push('/serie',
                                          extra: e.value[i]);
                                        },
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            // Add this line to set the border
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        imageCover(
                                                            e.value[i].id)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )),
                    )
                  ],
                )
              ]);
            }).toList()),
          )
        ],
      );
  }
}