import 'package:flutter/material.dart';
import '../../constants.dart';
import 'input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput(
      {Key? key, required this.hint, required this.value})
      : super(key: key);

  final String hint;
  final Function(String value_input) value;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      onChanged: value,
      cursorColor: kPrimaryColor,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none),
    ));
  }
}
