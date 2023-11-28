import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import '../gamer/game.dart';
import '../material/briks.dart';
import 'player_panel.dart';
import 'status_panel.dart';

const screenBackground = Color(0xfff0f0f0);

/// screen H : W;
class Screen extends StatelessWidget {
  ///the with of screen
  final Size size;

  const Screen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: Container(
        height: size.height,
        width: size.height * 0.4, // 40% da altura
        decoration: const BoxDecoration(
          color: screenBackground,
          border: Border.symmetric(
            vertical: BorderSide(color: Color(0x42000000)),
          ),
        ),
        child: BrikSize(
          size: Size.square((size.height * 0.4 - 6) / gamePadMatrixW),
          child: const Column(
            children: [
              // SizedBox(height: size.height * 0.06),
              PlayerPanel(),
              StatusPanelH(),
            ],
          ),
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;

  ///true to shake screen vertically
  final bool shake;

  const Shake({
    super.key,
    required this.child,
    required this.shake,
  });

  @override
  ShakeState createState() => ShakeState();
}

/// Sacudir a tela
class ShakeState extends State<Shake> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Vector3 _getTranslation() {
    return Vector3(0, sin(_controller.value * pi) * 2.5, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}
