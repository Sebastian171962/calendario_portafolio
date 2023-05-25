import 'package:calendario/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        userNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: const Color.fromARGB(85, 224, 219, 236),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: const Color.fromARGB(85, 224, 219, 236),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      color: const Color.fromARGB(255, 245, 216, 110),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 85),
        onPressed: () {
          Navigator.pushNamed(context, '/main'); // Navigate to the 'main' route
        },
        child: const Text(
          "Entrar",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

// Rest of the code remains the same

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 210,
                      child:
                          Image.asset("assets/logo.png", fit: BoxFit.contain),
                    ),
                    Container(
                      padding: const EdgeInsets.only(),
                      child: const Text(
                        'Inicio de sesion',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 216, 110),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 268),
                      child: const Text(
                        'Nombre Usuario',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    userNameField,
                    Container(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 268),
                      child: const Text(
                        'Contraseña',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    passwordField,
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistationPage()));
                          },
                          child: const Text(
                            "Registrate gratis ",
                            style: TextStyle(
                                color: Color.fromARGB(255, 245, 216, 110),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        const Text(
                          "si aun no tienes cuenta",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 45),
                    loginButton,
                    const SizedBox(height: 45)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
