import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/authentication/services/auth_service.dart';
import 'package:otakusama/feature/getStarted/screens/getStartedScreen.dart';
import 'package:otakusama/feature/homepage/screens/homepage_screen.dart';

void main() {
  runApp(
    ProviderScope(child: const MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    _authFuture = checkAuth(context);
  }

  Future<void> checkAuth(BuildContext context) async {
    await ref.read(authServiceProvider).getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = ref.watch(userProvider);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: user == null ? const GetStartedScreen() : HomePage());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
