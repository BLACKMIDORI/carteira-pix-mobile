import 'package:flutter/material.dart';

/// Source: https://stackoverflow.com/a/73822861
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    Key? key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize = 20,
    this.icon,
    required this.value,
    required this.onChanged,
    this.fillColor,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Widget? icon;
  final Color? fillColor;
  final bool value;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged.call(!value);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? Colors.grey.shade500,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: value
            ? icon ??
                Icon(
                  Icons.check,
                  size: iconSize,
                  color: fillColor,
                )
            : null,
      ),
    );
  }
}
