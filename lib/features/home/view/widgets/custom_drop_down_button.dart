import 'package:flutter/material.dart';

///{@template custom_drop_down_button}
/// A custom drop down button for this app that
/// allows the user to select a value.
/// {@endtemplate}
class CustomDropDownButton extends StatelessWidget {
  ///{@macro custom_drop_down_button}
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    required this.hint,
  });

  ///List of dropdown items.
  final List<DropdownMenuItem<String>> items;

  ///Callback for when the dropdown value is changed.
  final ValueChanged<String?> onChanged;

  /// Value of the dropdown widget
  final String? value;

  /// Hint of what the drop down items are
  final String hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      key: key,
      isExpanded: true,
      elevation: 16,
      style: const TextStyle(color: Colors.blue, fontSize: 14),
      hint: Text(hint),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
