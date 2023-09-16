import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/list_builder.dart';
import 'package:anirecord/presentation/views/home/navigation.dart';
import 'package:anirecord/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserCasePovider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              router.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: colorAppBar,
        elevation: 0,
        title: const Text(
          'Mi cuenta',
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: user.call()?.photoURL != null
                      ? CachedNetworkImage(
                          imageUrl: user.call()!.photoURL!,
                          width: 55,
                          height: 55,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.account_circle,
                              size: 40,
                              color: colorPrimaryInverted,
                            ),
                            onPressed: () {},
                          ),
                        )),
              title: Text(
                "Hola, ${user.call()?.displayName ?? user.call()?.email ?? ''}",
                style: const TextStyle(fontSize: 18),
              ),
              subtitle:  Text(user.call()?.email??"",style:const TextStyle(color: Colors.grey),),
              trailing: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                        onPressed: () async {
                          await ref.read(authSourceProvider).signOut();
                          ref.invalidate(albumProvider);
                          ref.read(bottomNavtigatonBarPorvider.notifier).state =
                              0;
                          router.pop();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                  )),
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "VERSIÓN 0.0.1",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Colors.grey),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
