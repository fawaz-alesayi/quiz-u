// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/api/name.dart';
import 'package:quiz_u_client/components/page_container.dart';
import 'package:quiz_u_client/main.dart';
import 'package:quiz_u_client/pages/otp.dart';

final nameProvider = StateProvider((ref) => '');

class NamePage extends ConsumerWidget {
  const NamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var name = ref.watch(nameProvider);
    var prefs = ref.watch(sharedPreferencesProvider).value;
    return PageContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'QuizU',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text('Enter your name'),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => ref.read(nameProvider.notifier).state = value,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "John Doe"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (name.trim().isEmpty) {
              showErrorSnackBar(context, 'Please enter a valid name');
            } else {
              var response = await updateName(
                  newName: name, token: prefs?.getString('token'));
              if (response == null) {
                showErrorSnackBar(context, 'Sorry, something went wrong');
              } else {
                await prefs?.setString('name', name);
                Navigator.pushReplacementNamed(context, Routes.navigation);
              }
            }
          },
          child: const Text('Continue'),
        ),
      ],
    ));
  }
}
