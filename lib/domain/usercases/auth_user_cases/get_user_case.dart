import 'package:anirecord/domain/repositories/auth_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetUserCase {
  final AuthRepositoryInterface repositoryInterface;

  GetUserCase(this.repositoryInterface);

  User? call() => repositoryInterface.getUser();
}