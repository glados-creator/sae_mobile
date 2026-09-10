import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart' as thingy;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../ViewModels/connexionViewModel.dart';

class ConnectionView extends StatefulWidget {
  const ConnectionView({super.key});

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isPasswordHide = true;
  bool _isLoading = false;

  Future<String> getDatabasePath() async {
    return "${await getDatabasesPath()}/database.db";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Se connecter"),
        ),
      ),
      body: thingy.Material(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const thingy.InputDecoration(
                          labelText: "Nom d'utilisateur",
                          border: thingy.OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(
                          errorText:
                              "Veuillez renseigner votre nom d'utilisateur",
                        ),
                      ),

                      const SizedBox(height: 20),

                      FormBuilderTextField(
                        name: 'password',
                        obscureText: _isPasswordHide,
                        decoration: thingy.InputDecoration(
                          labelText: 'Mot de passe',
                          border: const thingy.OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHide
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHide = !_isPasswordHide;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.required(
                          errorText: "Le champ est obligatoire",
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final String dbPath =
                                  await getDatabasePath();

                              setState(() {
                                _isLoading = true;
                              });

                              final String username = _formKey
                                  .currentState!
                                  .fields['username']!
                                  .value;

                              final String password = _formKey
                                  .currentState!
                                  .fields['password']!
                                  .value;

                              context
                                  .read<ConnexionViewModel>()
                                  .setUsername(username);

                              context
                                  .read<ConnexionViewModel>()
                                  .setPassword(password);

                              final bool isConnected = await context
                                  .read<ConnexionViewModel>()
                                  .loginUser(context, dbPath);

                              if (!mounted) {
                                return;
                              }

                              setState(() {
                                _isLoading = false;
                              });

                              if (isConnected) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Connexion réussie pour $username',
                                    ),
                                  ),
                                );

                                context.go('/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Nom d\'utilisateur ou mot de passe incorrect',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Se connecter'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        child: const Text(
                          'Pas de compte ? Inscrivez-vous',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
