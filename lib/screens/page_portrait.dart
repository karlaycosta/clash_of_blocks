import 'package:flutter/material.dart';

import '../panel/screen.dart';

class PagePortrait extends StatelessWidget {
  const PagePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Screen(size: size),
        // const SizedBox(height: 24),
        // const GameController(),
      ],
    );
  }
}
