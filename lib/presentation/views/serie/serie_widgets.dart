  import 'package:anirecord/domain/entities/serie_info_entity.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


  Widget shadow(double height) {
    return Container(
      height: height * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            
            0.55,
            0.7,
          ],
          colors: [
            
            Colors.transparent,
            Colors.white,
          ],
        ),
      ),
    );
  }

  Widget infoWidget(String season, int year, String status) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(
                Icons.sunny,
                
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                seasonConvert(season),
                
                style: GoogleFonts.openSans(),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.date_range,
                
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                year.toString(),
                style: GoogleFonts.openSans(),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.slow_motion_video,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                statusConvert(status),
                style: GoogleFonts.openSans(color: Colors.green),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget itemWidget(String id, String name, bool direction) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: 100,
        child: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                child: direction
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.keyboard_arrow_left,
                              size: 40, color: Colors.white),
                          Text(name,
                              style: GoogleFonts.openSans(color: Colors.white))
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(name,
                              style: GoogleFonts.openSans(color: Colors.white)),
                          const Icon(Icons.keyboard_arrow_right,
                              size: 40, color: Colors.white),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget prevNextWidget(SerieInfo serieInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (serieInfo.prev != null)
            Expanded(
                flex: 3,
                child:
                    itemWidget(serieInfo.prev!.id, serieInfo.prev!.name, true))
          else
            Expanded(flex: 3, child: Container()),
          const Expanded(
            flex: 1,
            child: SizedBox(
              width: 1,
              height: 25,
              child: VerticalDivider(
                
                thickness: 1,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.menu,
              
              size: 30,
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(
              width: 1,
              height: 25,
              child: VerticalDivider(
                
                thickness: 1,
              ),
            ),
          ),
          if (serieInfo.next != null)
            Expanded(
                flex: 3,
                child: itemWidget(
                    serieInfo.next!.id, serieInfo.next!.name, false))
          else
            Expanded(flex: 3, child: Container())
        ],
      ),
    );
  }

Route createRoute(String desc) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SerieDescriptionScreen(desc: desc),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}

class SerieDescriptionScreen extends StatelessWidget {
  final String desc;

  const SerieDescriptionScreen({super.key,required this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color(0xfff4f4f4),
        elevation: 1,
        title: Text("Descripción",style: GoogleFonts.openSans(color: Colors.black),),

        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.close,color: Colors.black,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(desc,style: GoogleFonts.openSans(fontSize: 17),),
      ),
    );
  }
}