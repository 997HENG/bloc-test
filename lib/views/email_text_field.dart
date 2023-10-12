import 'package:bloc_testing/strings.dart';
import 'package:flutter/material.dart';

class EmialTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmialTextField({
    super.key,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
