import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/components/midori_modal.dart';
import 'package:flutter/material.dart';

/// AboutAppDialog
class AboutAppDialog extends StatelessWidget {
  /// AboutAppDialog constructor
  const AboutAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MidoriModal(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/app-icon.png"),
            const Text(
              "Carteira Pix",
              style: TextStyle(
                color: purple,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const Text("Versão 1.1.0"),
            const Divider(),
            const Text("Por BLACKMIDORI"),
          ],
        ),
      ),
    );
  }
}
