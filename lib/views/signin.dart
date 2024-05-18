import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/helper/functions.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/views/home.dart';
import 'package:flutterapp/views/signup.dart';
import 'package:flutterapp/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  AuthService authService = AuthService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
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
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            children: [
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: Colors.white,
                      ), // Set text color to white
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: Colors.white,
                      ), // Set text color to white
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: Container(
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: signIn,
                      child: blueButton(context: context, label: "Sign In"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
