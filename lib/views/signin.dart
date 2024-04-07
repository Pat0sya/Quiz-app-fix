import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/views/home.dart';
import 'package:flutterapp/views/signup.dart';
import 'package:flutterapp/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService authService = new AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  signIn() async {
    if (_formKey.currentState!.validate()) {
      email = _emailController.text.trim();
      password = _passwordController.text.trim();

      setState(() {
        isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });

      // Call your sign-in method here
      // await authService.signInEmailAndPass(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBar(context),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more validation logic as needed
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more validation logic as needed
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: signIn,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? ',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Container(
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline,
                                  fontSize: 17)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
