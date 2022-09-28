import 'package:flutter/material.dart';

/// A scaffold + padding for all pages
class PageContainer extends StatelessWidget {
  const PageContainer(
      {Key? key,
      required this.child,
      this.xPadding = 32.0,
      this.yPadding = 32.0})
      : super(key: key);

  final Widget child;
  final double xPadding;
  final double yPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: xPadding, vertical: yPadding),
        child: child,
      ),
    );
  }
}
