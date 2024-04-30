import 'package:flutter/material.dart';

class BlackCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const BlackCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          value ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.black, // Change the color of the checkbox
        ),
      ),
    );
  }
}
