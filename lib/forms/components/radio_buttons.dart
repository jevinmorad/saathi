import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget radioButtons({
  required List<String> options,
  required String selectedValue,
  required Function(String) onChange,
}) {
  return Row(
    children: options.map((option) {
      bool isSelected = option == selectedValue;
      return Padding(
        padding: EdgeInsets.only(right: 12),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () => onChange(option),
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.grey.withOpacity(0.2),
            child: Container(
              padding: EdgeInsets.only(top: 4, right: 12, bottom: 4, left: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? CupertinoIcons.checkmark_alt_circle_fill
                        : CupertinoIcons.circle_fill,
                    color: isSelected ? Colors.cyan : Colors.grey.shade100,
                    size: 28,
                  ),
                  SizedBox(width: 6),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}