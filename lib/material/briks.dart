import 'package:flutter/material.dart';

const _colorNormal = Color(0xff241f31);

const _colorNull = Color(0xffdeddda);

const _colorHighLight = Color(0xff5e5c64);

const _colorGhost = Color(0xff9a9996);

class BrikSize extends InheritedWidget {
  final Size size;

  const BrikSize({
    super.key,
    required super.child,
    required this.size,
  });

  static BrikSize of(BuildContext context) {
    final brikSize = context.dependOnInheritedWidgetOfExactType<BrikSize>();
    assert(brikSize != null, 'BrikSize não encontrado!');
    return brikSize!;
  }

  @override
  bool updateShouldNotify(BrikSize oldWidget) => oldWidget.size != size;
}

///the basic brik for game panel
class Brik extends StatelessWidget {
  final Color color;
  final bool mini;

  const Brik._({
    super.key,
    this.mini = false,
    required this.color,
  });

  const Brik.normal({Key? key, bool mini = false})
      : this._(key: key, mini: mini, color: _colorNormal);

  const Brik.empty({Key? key, bool mini = false})
      : this._(key: key, mini: mini, color: _colorNull);

  const Brik.highlight({Key? key}) : this._(key: key, color: _colorHighLight);

  const Brik.ghost({Key? key}) : this._(key: key, color: _colorGhost);

  @override
  Widget build(BuildContext context) {
    final size =
        mini ? BrikSize.of(context).size / 2 : BrikSize.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(0.06 * size.width),
      decoration: BoxDecoration(
        border: Border.all(width: 0.08 * size.width, color: color),
      ),
      child: Container(color: color),
    );
  }
}
