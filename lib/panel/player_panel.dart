import 'package:flutter/material.dart';

import '../gamer/game.dart';
import '../main.dart';
import '../material/briks.dart';

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0x42000000)),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _PlayerPad(),
          _GameUninitialized(),
        ],
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = GameState.of(context).data;
    return Column(
      children: [
        for (final list in data)
          Row(
            children: [
              for (final item in list)
                switch (item) {
                  0 => const Brik.empty(),
                  1 => const Brik.normal(),
                  2 => const Brik.highlight(),
                  _ => const Brik.ghost(),
                }
            ],
          )
      ],
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return switch (GameState.of(context).states) {
      GameStates.none => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Clash of Blocks v$version',
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      _ => const SizedBox(),
    };
  }
}
