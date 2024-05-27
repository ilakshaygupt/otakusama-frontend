import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/authentication/services/auth_service.dart';
import 'package:otakusama/feature/offlineViewing/screens/offline_view_screen.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
          child: user != null
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    Text('Username: ${user.username}'),
                    const SizedBox(height: 20),
                    Text('Email: ${user.email}'),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OfflineViewScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                )
              : const Placeholder()),
    );
  }
}
