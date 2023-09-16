import 'package:anirecord/domain/repositories/auth_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource extends AuthRepositoryInterface{
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource(this.firebaseAuth);

  

  @override
  Stream<User?> authState() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Future<void> signGoogle() async {
  try {
    // ignore: body_might_complete_normally_catch_error
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((_){
      
    });

    if (googleUser == null) {
      // print('Inicio de sesión de Google cancelado.');
      return; // Cancela el proceso de inicio de sesión.
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Crea una credencial para el usuario
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    // print('Inicio de sesión de Google exitoso.');
  } on PlatformException catch (e) {
    switch (e.code) {
        case 'sign_in_canceled':
          // print('what was expected was printed');
          return;
      }
    // print('Error al iniciar sesión con Google: $e');
  }
}

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      } catch (e) {
        throw Exception(e.toString());
      }
  }

  @override
  Future<void> signOut()async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password, String username) async{
       final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;
        await user?.updateDisplayName(username);
        // await firebaseAuth.signInWithCredential(userCredential.credential!);
  }
  
  @override
  User? getUser() {
    return firebaseAuth.currentUser;
  }

}