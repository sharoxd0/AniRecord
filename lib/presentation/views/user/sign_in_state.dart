import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/sign_up_user_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SignUpState { loading, error, initial }

final emailTextErrorProvider = StateNotifierProvider<EmailTextErrorNotifier,String?>((ref) {
  return EmailTextErrorNotifier();
});

class EmailTextErrorNotifier extends StateNotifier<String?>{
  EmailTextErrorNotifier():super(null);

  void emailExist(String message){
    state = "El email ya existe";
  }

  void clear(){
    state = null;
  }
}

final signUpButtonProvider =
    StateNotifierProvider<SignUpButtonNotifer, SignUpState>(
  (ref) {
    final singUpUserCase = ref.watch(signUpProvider);
    final emailError = ref.read(emailTextErrorProvider.notifier);
    return SignUpButtonNotifer(singUpUserCase,emailError);
  },
);

class SignUpButtonNotifer extends StateNotifier<SignUpState> {
  SignUpButtonNotifer(this.signUpUserCase,this.emailTextErrorNotifier) : super(SignUpState.initial);
  final SignUpUserCase signUpUserCase;
final EmailTextErrorNotifier emailTextErrorNotifier;
  Future<void> signUp(String email, String password, String username) async {
    try {
      state = SignUpState.loading;
      emailTextErrorNotifier.clear();
      await signUpUserCase.call(email, password, username);
      state = SignUpState.initial;
    } catch (e) {
      emailTextErrorNotifier.emailExist("El email ya existe");
      state = SignUpState.error;
    }
  }
}
