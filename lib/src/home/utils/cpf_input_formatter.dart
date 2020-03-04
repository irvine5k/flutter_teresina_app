import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CPFInputFormatter extends TextInputFormatter {
  CPFInputFormatter() : super();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    var newText = newValue.text.replaceAll(RegExp('[^0-9]+'), '');

    if (newText.length > 2) {
      if (newText.length > 3) {
        newText = '${newText.substring(0, 3)}.${newText.substring(3)}';
      } else {
        newText = '${newText.substring(0, 3)}.';
      }
    }

    if (newText.length > 6) {
      if (newText.length > 7) {
        newText = '${newText.substring(0, 7)}.${newText.substring(7)}';
      } else {
        newText = '${newText.substring(0, 7)}.';
      }
    }

    if (newText.length > 10) {
      if (newText.length > 11) {
        newText = '${newText.substring(0, 11)}-${newText.substring(11)}';
      } else {
        newText = '${newText.substring(0, 11)}-';
      }
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
