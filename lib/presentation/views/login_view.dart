import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/presentation/views/auth/login_builder.dart';
import 'package:anirecord/presentation/views/home/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthBuilder extends ConsumerWidget {
  const AuthBuilder({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return auth.when(data: (data){
      if (data != null) {
            return const NavigationView();
          } else {
            return const LoginScreen();
          }
    }, error: (_,__){
      return Scaffold(body:Center(child: Text(__.toString())));
    }, loading: (){
      return const Scaffold(body: Center(child: CircularProgressIndicator(
        color: Colors.black,
      ),),);
    });
  }
}
