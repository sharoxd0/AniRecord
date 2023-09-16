import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/activity/activity_builder.dart';
import 'package:anirecord/presentation/views/home/library/library_view.dart';
import 'package:anirecord/presentation/views/home/list/list_builder.dart';
import 'package:anirecord/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavtigatonBarPorvider = StateProvider<int>((ref) => 0);

class NavigationView extends ConsumerStatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _NavigationViewState();
}

class _NavigationViewState extends ConsumerState<NavigationView> {
  String titleName(int i) {
    switch (i) {
      case 0:
        return "Novedades";
      case 1:
        return "Biblioteca";
      default:
        return "Mis listas";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavtigatonBarPorvider);
    final user = ref.watch(getUserCasePovider);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimaryInverted,
        onPressed: () {
          router.push('/create_album');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        
        actions: [Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                router.push('/profile');
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: user.call()?.photoURL != null
                    ? CachedNetworkImageProvider(user.call()!.photoURL!)
                        as ImageProvider<Object> // Casting explícito
                    : null, // Dejamos el backgroundImage como nulo
                backgroundColor: Colors.transparent,
                child: user.call()?.photoURL == null
                    ? const Icon(
                        Icons.account_circle,
                        size: 40,
                        color: colorPrimaryInverted,
                      )
                    : null, // Dejamos el child como nulo si hay una imagen de perfil
              ),
            )),
       ]
        , backgroundColor: colorAppBar,
        title: Text(
          titleName(currentIndex),
          style: const TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ActivityBuilder(),
          LibraryView(),
          FavoriteListV2(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: colorPrimaryInverted,
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavtigatonBarPorvider.notifier).state = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timelapse),
              label: 'Novedades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Biblioteca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Mi Album',
            ),
          ],
        ),
      ),
    );
  }
}
