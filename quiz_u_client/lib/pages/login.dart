// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_number/phone_number.dart';
import 'package:quiz_u_client/components/page_container.dart';
import 'package:quiz_u_client/components/drop_down.dart';
import 'package:quiz_u_client/main.dart';

final _formKey = GlobalKey<FormBuilderState>();

/// A provider that holds the selected region code for the phone number.
///
/// e.g.: "SA", "YE", "OM", "AE", "BH"
final dialogCode = StateProvider<String>((ref) => "SA");

final phoneNumberProvider = StateProvider<String>((ref) => "");

/// A page that contains a input form for a mobile number and a button to send an OTP.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedRegionCode = ref.watch(dialogCode);
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('QuizU'),
          const SizedBox(height: 20),
          const Text('Enter your mobile number'),
          const SizedBox(height: 20),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomDropDownButton(
                    items: const {
                      "+966": "SA",
                      "+967": "YE",
                      "+968": "OM",
                      "+971": "AE",
                      "+973": "BH",
                    },
                  )),
              Expanded(
                  child: FormBuilder(
                key: _formKey,
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "55 555 5555"),
                  name: 'phone_number',
                ),
              )),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              var phoneNumber =
                  _formKey.currentState!.fields['phone_number']!.value;
              var phoneNumberValid =
                  await validatePhoneNumber(phoneNumber, selectedRegionCode);

              if (phoneNumberValid) {
                ref.read(phoneNumberProvider.notifier).state =
                    formatPhoneNumber(phoneNumber);
                Navigator.pushNamed(context, Routes.otp);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid phone number')));
              }
            },
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }
}

Future<bool> validatePhoneNumber(String? phoneNumber, String regionCode) async {
  var isValid = false;
  if (phoneNumber == null) {
    return isValid;
  }
  try {
    isValid =
        await PhoneNumberUtil().validate(phoneNumber, regionCode: regionCode);
  } catch (e) {
    debugPrint(e.toString());
  }
  if (isValid) {
    debugPrint("$phoneNumber is a valid phone number");
  } else {
    debugPrint("$phoneNumber is NOT a valid phone number");
  }
  return isValid;
}

String formatPhoneNumber(String number) {
  return "0$number";
}
