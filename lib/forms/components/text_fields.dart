import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget sectionTitle({required String title}) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
  );
}

Widget textField({
  required TextEditingController controller,
  required String label,
  required FocusNode focusNode,
  FocusNode? nextFocusNode,
  int? maxLength,
  String? counterText,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool obscureText = false,
  bool readOnly = false,
  String? Function(String?)? validator,
  void Function(String?)? onChange,
  void Function(String?)? onFieldSubmitted,
  void Function()? onTap,
  int maxLine = 1,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    inputFormatters: inputFormatters,
    obscureText: obscureText,
    maxLines: maxLine,
    validator: validator,
    readOnly: readOnly,
    onChanged: onChange,
    maxLength: maxLength,
    onTap: onTap,
    focusNode: focusNode,
    textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
    onFieldSubmitted: onFieldSubmitted,
    cursorColor: Colors.cyan,
    textAlignVertical: TextAlignVertical.top,
    decoration: InputDecoration(
      counterText: counterText,
      labelText: label,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
      floatingLabelStyle: TextStyle(
        color: focusNode.hasFocus ? Colors.cyan : Colors.black.withOpacity(0.5),
      ),
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.cyan, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.cyan, width: 2),
      ),
    ),
  );
}