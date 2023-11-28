import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game.dart';

/// keyboard controller to play game
class KeyboardController extends StatelessWidget {
  final Widget child;

  const KeyboardController({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    RawKeyboard.instance.addListener((event) {
      if (event is RawKeyUpEvent) {
        return;
      }
      final game = Game.of(context);
      switch (event.data.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          game.rotate();
        case LogicalKeyboardKey.arrowDown:
          game.down();
        case LogicalKeyboardKey.arrowLeft:
          game.left();
        case LogicalKeyboardKey.arrowRight:
          game.right();
        case LogicalKeyboardKey.space:
          game.drop();
        case LogicalKeyboardKey.keyP:
          game.pauseOrResume();
        case LogicalKeyboardKey.keyS:
          game.soundSwitch();
        case LogicalKeyboardKey.keyR:
          game.reset();
      }
    });

    return child;
  }
}
