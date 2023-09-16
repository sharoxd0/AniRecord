import 'package:anirecord/data/datasources/firebase_auth_datasource.dart';
import 'package:anirecord/domain/repositories/auth_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends AuthRepositoryInterface{
  final FirebaseAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  @override
  Stream<User?> authState(){
    return  _dataSource.authState();
  }

  @override
  Future<void> signGoogle() async{
    
    return await _dataSource.signGoogle();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async{
    await _dataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async{
    await _dataSource.signOut();
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password,String username)async {
    
    return await  _dataSource.signUpWithEmailAndPassword(email, password, username);
  }
  
  @override
  User? getUser() {
    
    return _dataSource.getUser();
  }
}