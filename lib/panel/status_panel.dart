import 'dart:async';

import 'package:flutter/material.dart';

import '../gamer/block.dart';
import '../gamer/game.dart';
import '../material/briks.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.bold);
    const space = SizedBox(height: 4);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pontos\n${GameState.of(context).points}', style: bold),
          space,
          Text(
            'Limpezas\n${GameState.of(context).cleared}',
            // textAlign: TextAlign.center,
            style: bold,
          ),
          space,
          Text(
            'Nivel\n${GameState.of(context).level}',
            // textAlign: TextAlign.center,
            style: bold,
          ),
          space,
          const Text('Próximo', style: bold),
          space,
          _NextBlock(),
          const Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

class StatusPanelH extends StatelessWidget {
  const StatusPanelH({super.key});

  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.w500);
    const space = SizedBox(height: 8);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pontos\n${GameState.of(context).points}',
                textAlign: TextAlign.center,
                style: bold,
              ),
              Text(
                'Limpezas\n${GameState.of(context).cleared}',
                textAlign: TextAlign.center,
                style: bold,
              ),
              Text(
                'Nivel\n${GameState.of(context).level}',
                textAlign: TextAlign.center,
                style: bold,
              ),
              Column(
                children: [
                  const Text(
                    'Próximo',
                    style: bold,
                  ),
                  _NextBlock(),
                ],
              ),
              Column(
                children: [
                  IconButton.outlined(
                    onPressed: Game.of(context).soundSwitch,
                    icon: Icon(GameState.of(context).muted
                        ? Icons.music_off_rounded
                        : Icons.music_note_rounded),
                  ),
                ],
              ),
            ],
          ),
          space,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.outlined(
                onPressed: Game.of(context).left,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
              IconButton.outlined(
                onPressed: Game.of(context).down,
                icon: const Icon(
                  Icons.arrow_downward_rounded,
                ),
              ),
              //right
              IconButton.outlined(
                onPressed: Game.of(context).right,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                ),
              ),
              //rotate
              IconButton.outlined(
                onPressed: Game.of(context).rotate,
                icon: const Icon(
                  Icons.rotate_90_degrees_cw_outlined,
                ),
              ),
              IconButton.outlined(
                onPressed: Game.of(context).drop,
                icon: const Icon(
                  Icons.download,
                ),
              ),
              IconButton.outlined(
                onPressed: Game.of(context).reset,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = [List.filled(4, 0), List.filled(4, 0)];
    final next = pieces[GameState.of(context).next.type]!;
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: [
        for (final list in data)
          Row(
            children: [
              for (final item in list)
                item == 1
                    ? const Brik.normal(mini: true)
                    : const Brik.empty(mini: true)
            ],
          )
      ],
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;

  bool _colonEnable = true;

  int _minute = 0;

  int _hour = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(GameState.of(context).muted
            ? Icons.music_off_rounded
            : Icons.music_note_rounded),
        const SizedBox(width: 4),
        Icon(switch (GameState.of(context).states) {
          GameStates.paused => Icons.stop_rounded,
          GameStates.running => Icons.play_arrow_rounded,
          _ => Icons.close_rounded,
        }),
        const Spacer(),
        Text(
            '${_hour.toString().padLeft(2)}${_colonEnable ? ':' : '.'}${_minute.toString().padLeft(2)}'),
      ],
    );
  }
}
