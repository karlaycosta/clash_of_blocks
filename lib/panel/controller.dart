import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../gamer/game.dart';

class GameController extends StatelessWidget {
  const GameController({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(child: LeftController()),
          Expanded(child: DirectionController()),
        ],
      ),
    );
  }
}

const Size _directionButtonSize = Size(48, 48);

const Size _systemButtonSize = Size(28, 28);

const double _directionSpace = 16;

const double _iconSize = 16;

class DirectionController extends StatelessWidget {
  const DirectionController({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.fromSize(size: _directionButtonSize * 2.8),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_right,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_left,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: _directionSpace),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Button(
                      enableLongPress: false,
                      size: _directionButtonSize,
                      onTap: () {
                        Game.of(context).rotate();
                      }),
                  const SizedBox(width: _directionSpace),
                  _Button(
                      size: _directionButtonSize,
                      onTap: () {
                        Game.of(context).right();
                      }),
                ],
              ),
              const SizedBox(height: _directionSpace),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Button(
                      size: _directionButtonSize,
                      onTap: () {
                        Game.of(context).left();
                      }),
                  const SizedBox(width: _directionSpace),
                  _Button(
                    size: _directionButtonSize,
                    onTap: () {
                      Game.of(context).down();
                    },
                  ),
                ],
              ),
              const SizedBox(height: _directionSpace),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemButtonGroup extends StatelessWidget {
  static const _systemButtonColor = Color(0xFF2dc421);

  const SystemButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Description(
          text: 'Som',
          child: _Button(
              size: _systemButtonSize,
              color: _systemButtonColor,
              enableLongPress: false,
              icon: Icon(GameState.of(context).muted
                  ? Icons.music_off_rounded
                  : Icons.music_note_rounded),
              onTap: () {
                Game.of(context).soundSwitch();
              }),
        ),
        _Description(
          text: switch (GameState.of(context).states) {
            GameStates.paused => 'Continuar',
            GameStates.running => 'Pausar',
            _ => 'Iniciar',
          },
          child: _Button(
              size: _systemButtonSize,
              color: _systemButtonColor,
              enableLongPress: false,
              icon: Icon(switch (GameState.of(context).states) {
                GameStates.paused => Icons.play_arrow_rounded,
                GameStates.running => Icons.stop_rounded,
                _ => Icons.arrow_right_alt_rounded,
              }),
              onTap: () {
                Game.of(context).pauseOrResume();
              }),
        ),
        _Description(
          text: 'Reiniciar',
          child: _Button(
              size: _systemButtonSize,
              enableLongPress: false,
              color: Colors.red,
              icon: const Icon(Icons.restart_alt_rounded),
              onTap: () {
                Game.of(context).reset();
              }),
        )
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  const DropButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Description(
      text: 'drop',
      child: _Button(
          enableLongPress: false,
          size: const Size(90, 90),
          icon: const Icon(Icons.abc),
          onTap: () {
            Game.of(context).drop();
          }),
    );
  }
}

class LeftController extends StatelessWidget {
  const LeftController({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SystemButtonGroup(),
        Expanded(
          child: Center(
            child: DropButton(),
          ),
        )
      ],
    );
  }
}

///show a hint text for child widget
class _Description extends StatelessWidget {
  final String text;

  final Widget child;

  final AxisDirection direction;

  const _Description({
    required this.text,
    required this.child,
    this.direction = AxisDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(width: 8);
    const style = TextStyle(fontSize: 12, color: Colors.black);
    return switch (direction) {
      AxisDirection.right => Row(
          mainAxisSize: MainAxisSize.min,
          children: [child, space, Text(text, style: style)]),
      AxisDirection.left => Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text(text, style: style), space, child]),
      AxisDirection.up => Column(
          mainAxisSize: MainAxisSize.min,
          children: [child, space, Text(text, style: style)]),
      _ => Column(
          mainAxisSize: MainAxisSize.min,
          children: [child, space, Text(text, style: style)],
        ),
    };
  }
}

class _Button extends StatefulWidget {
  final Size size;
  final Widget? icon;

  final VoidCallback onTap;

  ///the color of button
  final Color color;

  final bool enableLongPress;

  const _Button({
    required this.size,
    required this.onTap,
    this.icon,
    this.color = Colors.blue,
    this.enableLongPress = true,
  });

  @override
  _ButtonState createState() {
    return _ButtonState();
  }
}

class _ButtonState extends State<_Button> {
  Timer? _timer;

  bool _tapEnded = false;

  late Color _color;

  @override
  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = widget.color;
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      elevation: 2,
      shape: const CircleBorder(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) async {
          setState(() {
            _color = widget.color.withOpacity(0.5);
          });
          if (_timer != null) {
            return;
          }
          _tapEnded = false;
          widget.onTap();
          if (!widget.enableLongPress) {
            return;
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (_tapEnded) {
            return;
          }
          _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
            if (!_tapEnded) {
              widget.onTap();
            } else {
              t.cancel();
              _timer = null;
            }
          });
        },
        onTapCancel: () {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        onTapUp: (_) {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        child: SizedBox.fromSize(
          size: widget.size,
          child: widget.icon,
        ),
      ),
    );
  }
}
