import 'package:anirecord/domain/repositories/auth_repository_interface.dart';

class SignOutUserCase {
  final AuthRepositoryInterface repositoryInterface;

  SignOutUserCase(this.repositoryInterface);

  Future<void> call() async =>await  repositoryInterface.signOut();
}