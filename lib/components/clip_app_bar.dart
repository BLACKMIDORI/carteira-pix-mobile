import 'package:flutter/cupertino.dart';

import '../utils/black_midori_clipper.dart';

class ClipAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const ClipAppBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const BlackMidoriClipper(
        lt: false,
        rt: false,
      ),
      child: child,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
