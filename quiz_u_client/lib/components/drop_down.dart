// ignore_for_file: annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/pages/login.dart';

/// A drop down button that takes a map of labels and values and a callback function.
class CustomDropDownButton extends ConsumerStatefulWidget {
  CustomDropDownButton({
    Key? key,
    required this.items,
    this.onChanged,
    this.initialItem,
  }) : super(key: key);

  /// A map of labels and values.
  final Map<String, String> items;
  final void Function(String?)? onChanged;
  String? initialItem;

  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends ConsumerState<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    var value = ref.watch(dialogCode);
    return DropdownButton<String>(
      items: widget.items.entries
          .map((e) => DropdownMenuItem<String>(
                value: e.value,
                child: Text(e.key,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    )),
              ))
          .toList(),
      onChanged: (String? val) {
        if (val != null) {
          ref.read(dialogCode.notifier).state = val;
        }
        if (widget.onChanged != null) {
          widget.onChanged!(val);
        }
      },
      value: value ?? widget.initialItem ?? widget.items.values.first,
    );
  }
}
