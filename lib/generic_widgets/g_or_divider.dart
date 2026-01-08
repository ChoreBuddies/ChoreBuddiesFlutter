import 'package:flutter/material.dart';

class GOrDivider extends StatelessWidget {
  const GOrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("OR", style: TextStyle(color: Colors.grey[500])),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
