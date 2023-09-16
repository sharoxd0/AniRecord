import 'package:anirecord/domain/repositories/auth_repository_interface.dart';

class SignUpUserCase {
  final AuthRepositoryInterface repositoryInterface;

  SignUpUserCase(this.repositoryInterface);

  Future<void> call(String email,String password,String username)async =>await  repositoryInterface.signUpWithEmailAndPassword(email, password,username);
}