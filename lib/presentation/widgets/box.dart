import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const Box({super.key, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: const Color(0xFFBABABA).withOpacity(0.1325),
            blurRadius: 6,
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(10),
      margin:
          margin ?? const EdgeInsets.only(bottom: 10.0, left: 15, right: 15),
      child: child,
    );
  }
}
