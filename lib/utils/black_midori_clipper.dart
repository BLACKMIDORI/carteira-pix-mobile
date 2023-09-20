import 'package:flutter/material.dart';

class BlackMidoriClipper extends CustomClipper<Path> {
  final bool lt;
  final bool rt;
  final bool lb;
  final bool rb;
  final double borderLength;

  /// BlackMidoriClipper constructor
  const BlackMidoriClipper({
    this.lt = true,
    this.rt = true,
    this.lb = true,
    this.rb = true,
    this.borderLength = 0.077,
  });

  @override
  Path getClip(Size size) {
    final borderHeight = size.height * borderLength;
    final borderWidth = size.width * borderLength;
    final path = Path()
      ..lineTo(0.0, lt ? borderHeight : 0)
      ..lineTo(0.0, size.height - (lb ? borderHeight : 0))
      ..lineTo(borderWidth, size.height)
      ..lineTo(size.width - borderWidth, size.height)
      ..lineTo(size.width, size.height - (rb ? borderHeight : 0))
      ..lineTo(size.width, borderHeight)
      ..lineTo(size.width - (rt ? borderWidth : 0), 0.0)
      ..lineTo(borderWidth, 0.0)
      ..lineTo(0.0, lt ? borderHeight : 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
