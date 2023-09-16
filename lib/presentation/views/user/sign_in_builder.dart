import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/auth/login_builder.dart';
import 'package:anirecord/presentation/views/user/sign_in_state.dart';
import 'package:anirecord/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInBuilder extends StatefulWidget {
  const SignInBuilder({super.key});

  @override
  State<SignInBuilder> createState() => _SignInBuilderState();
}

class _SignInBuilderState extends State<SignInBuilder> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepitController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepitController.dispose();
    _userNameController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _textFieldWidget(String title, TextEditingController controller,
      {bool obscureText = false,
      String? Function(String?)? validator,
      FocusNode? focusNode,
      String? errorText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: title,
          errorText: errorText,
          enabledBorder: const OutlineInputBorder(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su correo electrónico.';
    }
    if (!value.isValidEmail()) {
      return 'Por favor, ingrese su correo electrónico.';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su nombre de usuario.';
    }
    // Puedes agregar otras validaciones personalizadas aquí si es necesario.
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su contraseña.';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return null;
  }

  String? _validatePasswordRepeat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su contraseña.';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  Widget stateButton(SignUpState state) {
    switch (state) {
      case SignUpState.loading:
        return const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        );
      case SignUpState.initial:
        return const Icon(Icons.person_add);
      default:
        return const Icon(Icons.person_add);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(signUpButtonProvider);
      final errorMessage = ref.watch(emailTextErrorProvider);
      return Scaffold(
        backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Realizar la acción de registro aquí

                try {
                  await ref.read(signUpButtonProvider.notifier).signUp(
                      _emailController.text,
                      _passwordController.text,
                      _userNameController.text);
                  router.pop();
                } catch (e) {
                  
                  if (e is FirebaseAuthException &&
                      e.code == 'email-already-in-use') {
                    // Si el correo electrónico ya está en uso, muestra el error en el TextFormField.
                    // print('Error de autenticación: $e');
                    _emailFocusNode.requestFocus();
                  } else {
                    // Manejar otros errores de autenticación aquí.
                    // print('Error de autenticación: $e');
                  }
                }
              }
            },
            backgroundColor: colorPrimaryInverted,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              // child:  CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),
              child: stateButton(state),
            ),
          ),
          appBar: AppBar(
            backgroundColor: colorAppBar,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  router.pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registro',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colorPrimaryInverted),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 10, bottom: 10),
                          child: Text(
                            'Ingresa tu informacion y crea una nueva cuenta',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        _textFieldWidget('E-mail', _emailController,
                            validator: _validateEmail,
                            focusNode: _emailFocusNode,
                            errorText: errorMessage),
                        _textFieldWidget(
                            'Nombre de usuario', _userNameController,
                            validator: _validateUsername),
                        _textFieldWidget('Contraseña', _passwordController,
                            validator: _validatePassword, obscureText: true),
                        _textFieldWidget(
                            'Repita su contraseña', _passwordRepitController,
                            validator: _validatePasswordRepeat,
                            obscureText: true),
                        const SizedBox(height: 80)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
