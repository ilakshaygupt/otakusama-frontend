// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/authentication/screens/login_screen.dart';
import 'package:otakusama/feature/authentication/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterField extends StatefulWidget {
  const RegisterField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.icon,
      this.isVisible,
      this.maxlines,
      this.suffixIcon});
  final String hintText;
  final IconData? icon;
  final bool? isVisible;
  final bool? suffixIcon;
  final int? maxlines;
  final TextEditingController controller;

  @override
  State<RegisterField> createState() => _RegisterFieldState();
}

class _RegisterFieldState extends State<RegisterField> {
  @override
  Widget build(BuildContext context) {
    // print(widget.controller.text);
    return TextField(
      obscureText: widget.isVisible ?? false,
      maxLines: widget.maxlines ?? 1,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        hintText: widget.hintText,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        // icon: Icon(Icons.person),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  int selectedOption = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? translation;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void register(BuildContext context) {
    ref.watch(authServiceProvider).signUpUser(
          context: context,
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF46474B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: Center(
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 1),
                            
                            title: Text(
                              "User",
                              style: TextStyle(
                                color: selectedOption == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RegisterField(
                hintText: "Full Name",
                controller: _nameController,
                icon: Icons.person,
              ),
              const SizedBox(
                height: 30,
              ),
              RegisterField(
                  hintText: "User@gmail.com",
                  controller: _emailController,
                  icon: Icons.mail),
              const SizedBox(
                height: 30,
              ),
              RegisterField(
                hintText: "Password",
                controller: _passwordController,
                icon: Icons.lock,
                isVisible: true,
              ),
              const SizedBox(
                height: 30,
              ),
              RegisterField(
                hintText: "Confirm Password",
                controller: _confirmPasswordController,
                icon: Icons.lock,
                isVisible: true,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  register(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF004D14),
                        Color(0xFF098904),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Registered? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xFF046200), fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
