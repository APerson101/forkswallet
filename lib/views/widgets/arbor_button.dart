import 'package:arbor/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../core/constants/arbor_colors.dart';

class ArborButton extends StatefulWidget {
  final String title;
  Color? backgroundColor;
  final VoidCallback onPressed;
  final bool loading;
  final bool disabled;

  ArborButton(
      {required this.title,
      this.backgroundColor,
      required this.onPressed,
      this.disabled = false,
      this.loading = false});

  @override
  State<ArborButton> createState() => _ArborButtonState();
}

class _ArborButtonState extends State<ArborButton> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ThemeController _theme = Get.find();
      print(_theme.dark.value);
      var backgroundColor = _theme.dark.value
          ? ThemeData.dark().backgroundColor
          : Colors.purple[200];
      print(backgroundColor.toString());

      return RawMaterialButton(
        hoverColor: Colors.transparent,
        elevation: 0.0,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        fillColor: widget.disabled || widget.loading
            ? backgroundColor!.withOpacity(0.2)
            : backgroundColor,
        highlightElevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        animationDuration: Duration.zero,
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: widget.disabled || widget.loading ? () {} : widget.onPressed,
        child: Center(
          child: widget.loading
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ArborColors.white,
                    ),
                  ),
                )
              : Text(
                  '${widget.title}',
                  style: const TextStyle(
                      // color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ).constrained(minWidth: 72.0, minHeight: 36.0);
    });
  }
}
