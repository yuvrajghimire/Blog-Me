import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.textInputType,
      required this.hintText,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w600, color: Colors.black38, fontSize: 14),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
