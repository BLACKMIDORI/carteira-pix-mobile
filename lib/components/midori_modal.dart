import 'package:carteira_pix/black_midori_theme.dart';
import 'package:flutter/material.dart';

/// MidoriModal
class MidoriModal extends StatelessWidget {
  /// Modal content
  final Widget child;

  /// MidoriModal constructor
  const MidoriModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: brandColor,
        content: child,
      ),
    );
  }
}
