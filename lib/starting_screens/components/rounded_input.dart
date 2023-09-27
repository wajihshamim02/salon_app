import 'package:flutter/material.dart';
import '../../constants.dart';
import 'input_container.dart';

class RoundedInput extends StatefulWidget {
  final String hintText;
  final String labeltext;
  final IconData? prefixicon;
  final TextInputType inputtype;
  final Color borerColor;
  bool obsecuretext;
  final double? height;
  final TextEditingController controller;
  final IconData? suffixicon;
  final IconData? suffixIcon2;
  final FormFieldValidator<String> validator;
  final int? maxLines;

  RoundedInput({
    Key? key,
    required this.hintText,
    required this.labeltext,
    this.prefixicon,
    required this.borerColor,
    required this.obsecuretext,
    required this.inputtype,
    this.maxLines,
    required this.controller,
    required this.validator,
    this.suffixicon,
    this.suffixIcon2,
    this.height,
  }) : super(key: key);

  // final IconData icon;
  // final String hint;
  // final Function(String value_input) value;

  @override
  State<RoundedInput> createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput> {
  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextFormField(
      validator: widget.validator,
      style: TextStyle(fontSize: 15),
      controller: widget.controller,
      keyboardType: widget.inputtype,
      obscureText: widget.obsecuretext,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
          prefixIcon: IconTheme(
            data: IconThemeData(color: Colors.blue),
            child: Icon(
              widget.prefixicon,
            ),
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                widget.obsecuretext = !widget.obsecuretext;
                setState(() {});
              },
              child: widget.obsecuretext
                  ? Icon(
                      widget.suffixIcon2,
                      color: Colors.blue,
                      size: 28,
                    )
                  : Icon(
                      widget.suffixicon,
                      color: Colors.blue,
                      size: 28,
                    )),
          border: InputBorder.none),
    ));
  }
}
