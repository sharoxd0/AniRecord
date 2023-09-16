import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/sign_in_with_emial_and_password_user_case.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum StateLogin { initial, loading, error, data }

final stateButtonLoginProvier =
    StateNotifierProvider<StateButtonLoginNotifier, StateLogin>((ref) {
  final metodoEmail = ref.watch(signInWithEmailProvider);
  return StateButtonLoginNotifier(metodoEmail);
});

class StateButtonLoginNotifier extends StateNotifier<StateLogin> {
  final SingInWithEmailAndPasswordUserCase signInWithEmailAndPasswordUseCases;
  StateButtonLoginNotifier(this.signInWithEmailAndPasswordUseCases)
      : super(StateLogin.data);

  Future<void> onPress(
      String email, String password, BuildContext context) async {
    try {
      state = StateLogin.loading;
      await signInWithEmailAndPasswordUseCases.call(email, password);
      state = StateLogin.data;
    } catch (e) {
      state = StateLogin.error;
      ScaffoldMessengerState().showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      state = StateLogin.data;
    }
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool isFocused = false;
  bool isFocusedPassword = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
    _emailFocusNode.addListener(() {
      setState(() {
        isFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        isFocusedPassword = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget iconLogin(StateLogin state) {
    switch (state) {
      case StateLogin.data:
        return const Icon(Icons.arrow_forward_ios);
      case StateLogin.loading:
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      case StateLogin.error:
        return const Icon(Icons.close);
      default:
        return const Icon(Icons.arrow_forward_ios);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final stateButton = ref.watch(stateButtonLoginProvier);
      final button = ref.read(stateButtonLoginProvier.notifier);
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorPrimaryInverted,
          onPressed: (stateButton != StateLogin.data)
              ? null
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      button.onPress(_emailController.text,
                          _passwordController.text, context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error al iniciar sesión')),
                      );
                    }
                  }
                },
          child: iconLogin(stateButton),
        ),
        body: KeyboardVisibilityBuilder(builder: (context, isVisibilty) {
          final minHeight = isVisibilty
              ? MediaQuery.of(context).size.height * 0.7
              : MediaQuery.of(context).size.height;
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight:
                        minHeight, // Altura mínima para permitir el desplazamiento vertical
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'Inico de sesion',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colorPrimaryInverted),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 10, bottom: 20),
                          child: Text(
                            'Bienvenido',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: isFocused ? Colors.blue : Colors.grey),
                            labelText: 'E-mail',
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey), // Set the border color to white
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.isValidEmail()) {
                              return 'Ingresa un email correcto.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                                color: isFocusedPassword
                                    ? Colors.blue
                                    : Colors.grey),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey), // Set the border color to white
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Ingresa una contraseña correcta';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("¿No tienes una cuenta?"),
                            TextButton(
                                onPressed: () {
                                  router.push('/signin');
                                },
                                child: const Text(
                                  "Registrate",
                                  style: TextStyle(color: colorPrimaryInverted),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            const Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                  "O",
                                  style: TextStyle(color: Colors.black),
                                ))),
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: GestureDetector(
                            //
                            onTap: () async {
                              try {
                                final GoogleSignInAccount? googleUser =
                                    await GoogleSignIn().signIn();

                                if (googleUser == null) {
                                  // User canceled the sign-in
                                  // print('Google Sign In canceled');
                                  return; // Cancel the process gracefully.
                                }

                                // Create a credential for the user
                                final GoogleSignInAuthentication auth =
                                    await googleUser.authentication;

                                final AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: auth.accessToken,
                                  idToken: auth.idToken,
                                );
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);

                                // Use the credential to sign in
                                // ...
                              } catch (e) {
                                if (e is Exception) {
                                  // print('Error during Google Sign In: $e');
                                }
                              }
                            },
                            child: Container(
                              width: 50, // Ancho del círculo
                              height: 50, // Alto del círculo
                              decoration: BoxDecoration(
                                color: ThemeData().scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey, // Color de la sombra
                                    blurRadius: 4.0, // Radio de difuminación
                                    spreadRadius: 1.0, // Radio de propagación
                                    offset: Offset(0,
                                        0), // Desplazamiento de la sombra (elevación)
                                  ),
                                ],
                                image: const DecorationImage(
                                  fit: BoxFit
                                      .cover, // Ajusta cómo se ajusta la imagen dentro del círculo
                                  image: AssetImage('assets/google_icon.webp'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
