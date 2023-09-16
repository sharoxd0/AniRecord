import 'package:anirecord/domain/repositories/auth_repository_interface.dart';

class SignInGoogleUserCase{
  final AuthRepositoryInterface repositoryInterface;

  SignInGoogleUserCase(this.repositoryInterface);

  Future<void> call ()async=>await repositoryInterface.signGoogle();

}