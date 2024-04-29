import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/authentication/screens/sign_in_screen.dart';
import 'package:otakusama/feature/authentication/services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginScreen> {
// final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? translation;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void login(BuildContext context, WidgetRef ref) {
    ref.watch(authServiceProvider).signInUser(
          context: context,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          ref: ref,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF46474B),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 1,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RegisterField(
                  hintText: "example@gmail.com",
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
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  login(context, ref);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 98, 0, 0),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Do not have account? ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Color.fromARGB(255, 98, 0, 7), fontSize: 16),
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
