import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/components/PageContainer.dart';

class NamePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageContainer(
        child: Column(
      children: [
        const Text('Name Page'),
      ],
    ));
  }
}
