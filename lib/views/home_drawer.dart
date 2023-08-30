import 'dart:math';

import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/views/about_app_dialog.dart';
import 'package:flutter/material.dart';

/// HomeDrawer
class HomeDrawer extends StatefulWidget {
  /// HomeDrawer constructor
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void _onAboutClick() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (_) {
        return const AboutAppDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Stack(
              children: [
                ClipRRect(
                  child: Transform.scale(
                    scale: 10,
                    child: Transform.rotate(
                      angle: pi / 4,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: brandColor,
                              child: Text(" "),
                            ),
                          ),
                          Expanded(
                            child: ColoredBox(
                              color: black,
                              child: Text(" "),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: Image.asset("assets/images/app-icon.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  color: purple,
                  height: 4,
                  thickness: 4,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: brandColor,
                  ),
                  title: const Text("Sobre"),
                  onTap: _onAboutClick,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
