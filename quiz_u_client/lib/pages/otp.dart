// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quiz_u_client/api/login.dart';
import 'package:quiz_u_client/components/PageContainer.dart';
import 'package:quiz_u_client/main.dart';
import 'package:quiz_u_client/pages/login.dart';
import 'package:quiz_u_client/utils/auth_redirect.dart';

final otpProvider = StateProvider<String>((ref) => "");

/// A page that contains a input form for a mobile number and a button to send an OTP.
class OtpPage extends ConsumerWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var otp = ref.watch(otpProvider);
    var phoneNumber = ref.watch(phoneNumberProvider);
    var sharedPrefs = ref.watch(sharedPreferencesProvider).value;

    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text input for entering the OTP. the OTP is 4 digits and these digits should be separated.
          const Text(
            'Enter the OTP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          PinCodeTextField(
            appContext: context,
            length: 4,
            onChanged: (value) {
              ref.read(otpProvider.notifier).state = value;
            },
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              activeColor: Colors.black,
              inactiveColor: Colors.black,
              inactiveFillColor: Colors.white,
              selectedColor: Colors.black,
              selectedFillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (otp.length != 4) {
                showErrorSnackBar(context, 'Please enter a valid OTP');
              } else {
                var response = await login(otp: otp, phoneNumber: phoneNumber);
                if (response == null) {
                  showErrorSnackBar(context, "Sorry! Something went wrong");
                } else if (!response.success) {
                  if (response.message == 'Unauthorized! Your OTP is invalid') {
                    showErrorSnackBar(context, 'Invalid OTP');
                  } else {
                    showErrorSnackBar(context, "Sorry! Something went wrong");
                  }
                } else {
                  // save the token in shared preferences
                  sharedPrefs!.setString('token', response.token);

                  if (response.name == null) {
                    Navigator.pushReplacementNamed(context, Routes.name);
                    return;
                  }
                }
                Navigator.pushReplacementNamed(context, Routes.navigation);
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  ));
}
