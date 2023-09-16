import 'package:anirecord/domain/repositories/auth_repository_interface.dart';

class SingInWithEmailAndPasswordUserCase{
  final AuthRepositoryInterface authRepositoryInterface;

  SingInWithEmailAndPasswordUserCase(this.authRepositoryInterface);


  Future<void> call(String email,String password)async => await authRepositoryInterface.signInWithEmailAndPassword(email, password);
}