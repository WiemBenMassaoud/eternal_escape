import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -3 * ((value + index * 0.3) % 1.0)),
          child: Container(width: 6, height: 6, decoration: BoxDecoration(color: Color(0xFF6C63FF), shape: BoxShape.circle)),
        );
      },
      onEnd: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12, right: 60),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 3))]),
        child: Row(mainAxisSize: MainAxisSize.min, children: [ _buildDot(0), SizedBox(width: 4), _buildDot(1), SizedBox(width: 4), _buildDot(2) ]),
      ),
    );
  }
}