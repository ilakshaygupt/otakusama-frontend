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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: isLandscape
                              ? size.height * 0.1
                              : size.height * 0.3),
                      _buildWelcomeText(size, isLandscape),
                      SizedBox(
                          height: isLandscape
                              ? size.height * 0.05
                              : size.height * 0.08),
                      _buildButtons(context, size, user, isLandscape),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(Size size, bool isLandscape) {
    double fontSize = isLandscape ? size.height * 0.08 : size.width * 0.1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'OtakuSama.',
          style: TextStyle(
            color: Colors.red,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(
      BuildContext context, Size size, dynamic user, bool isLandscape) {
    return Flex(
      direction: isLandscape ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          context: context,
          label: 'Sign in',
          color: const Color.fromARGB(255, 78, 81, 93),
          onPressed: () {
            user == null
                ? Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Register()),
                  )
                : Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
          },
          isLandscape: isLandscape,
        ),
        SizedBox(
            width: isLandscape ? size.width * 0.05 : 0,
            height: isLandscape ? 0 : size.height * 0.02),
        _buildButton(
          context: context,
          label: 'Watch Now',
          color: Colors.red,
          onPressed: ()  {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
          isLandscape: isLandscape,
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required bool isLandscape,
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: isLandscape ? size.height * 0.1 : size.height * 0.07,
      width: isLandscape ? size.width * 0.3 : size.width * 0.8,
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
            fontSize: isLandscape ? size.height * 0.03 : size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
