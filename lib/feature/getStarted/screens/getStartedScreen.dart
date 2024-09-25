import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/authentication/screens/sign_in_screen.dart';
import 'package:otakusama/feature/authentication/services/auth_service.dart';
import 'package:otakusama/feature/homepage/screens/homepage_screen.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  late ImageProvider _backgroundImage;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _backgroundImage = const AssetImage('assets/IntroImage.png');
    _backgroundImage.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black, //
      body: Stack(
        children: [
          Container(color: Colors.black),
          AnimatedOpacity(
            opacity: _imageLoaded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.5),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'OtakuSama.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: size.width * 0.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(
                            context: context,
                            label: 'Sign in',
                            color: const Color.fromARGB(255, 78, 81, 93),
                            onPressed: () async {
                              user == null
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Register()),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()),
                                    );
                            },
                          ),
                          _buildButton(
                            context: context,
                            label: 'Watch Now',
                            color: Colors.red,
                            onPressed: () async {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      width: size.width * 0.4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
