import 'package:anirecord/data/datasources/firebase_auth_datasource.dart';
import 'package:anirecord/data/repositories/auth_repository.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/get_user_case.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/sign_in_with_emial_and_password_user_case.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/sign_out.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/sign_up_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/sign_in_google_user_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(FirebaseAuth.instance);
});

final authReposiotryProvider = Provider<AuthRepository>((ref){
  final repository = ref.watch(authSourceProvider);
  return AuthRepository(repository);
});

final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final signInWithEmailProvider = Provider<SingInWithEmailAndPasswordUserCase>((ref) {
  final repository = ref.watch(authReposiotryProvider);
  return SingInWithEmailAndPasswordUserCase(repository);
});
final signOutProvider = Provider<SignOutUserCase>((ref){
  final repository = ref.watch(authReposiotryProvider);
  return SignOutUserCase(repository);
});

final getUserCasePovider = Provider<GetUserCase>((ref) {
    final repository = ref.watch(authReposiotryProvider);
    return GetUserCase(repository);
},);

final signInGoogleProvider =  Provider<SignInGoogleUserCase>((ref){
final repository = ref.watch(authReposiotryProvider);
return SignInGoogleUserCase(repository);
});

final signUpProvider = Provider<SignUpUserCase>((ref) {
    final repository = ref.watch(authReposiotryProvider);
    return SignUpUserCase(repository);
},);