import 'package:calendario/login_page.dart';
import 'package:flutter/material.dart';

class RegistationPage extends StatefulWidget {
  const RegistationPage({Key? key}) : super(key: key);

  @override
  State<RegistationPage> createState() => _RegistationPageState();
}

class _RegistationPageState extends State<RegistationPage> {
  final _forKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final userNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        userNameEditingController.text = value!;
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

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
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
      controller: passwordEditingController,
      obscureText: _obscureText,
      onSaved: (value) {
        passwordEditingController.text = value!;
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

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: _obscureText,
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
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

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      color: const Color.fromARGB(255, 245, 216, 110),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 85),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: const Text(
          "Confirmar",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 245, 216, 110)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _forKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 180,
                      child:
                          Image.asset("assets/logo.png", fit: BoxFit.contain),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 50.0, right: 268),
                      child: const Text(
                        'Registrate',
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
                            color: Color.fromARGB(255, 245, 216, 110),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    userNameField,
                    Container(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 345),
                      child: const Text(
                        'E-mail',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 216, 110),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    emailField,
                    Container(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 310),
                      child: const Text(
                        'Contraseña',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 216, 110),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    passwordField,
                    Container(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 225),
                      child: const Text(
                        'Confirmar contraseña',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 216, 110),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    confirmPasswordField,
                    const SizedBox(height: 45),
                    signUpButton,
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
