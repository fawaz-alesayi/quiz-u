import 'package:flutter/material.dart';

class AnimatedElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          widget.onPressed();
        },
        child: isLoading
            ? Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
            )
            : Text(
                widget.text,
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
