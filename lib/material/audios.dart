import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

const _sounds = [
  'clean.mp3',
  'drop.mp3',
  'explosion.mp3',
  'move.mp3',
  'rotate.mp3',
  'start.mp3'
];

class Sound extends StatefulWidget {
  final Widget child;

  const Sound({super.key, required this.child});

  @override
  SoundState createState() => SoundState();

  static SoundState of(BuildContext context) {
    final state = context.findAncestorStateOfType<SoundState>();
    assert(state != null, 'can not find Sound widget');
    return state!;
  }
}

class SoundState extends State<Sound> {
  late Soundpool _pool;

  final _soundIds = <String, int>{};

  bool mute = false;

  Future<void> _play(String name) async {
    final soundId = _soundIds[name];
    if (soundId != null && !mute) {
      _pool.play(soundId);
    }
  }

  @override
  void initState() {
    super.initState();
    _pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(maxStreams: 6),
    );
    for (final value in _sounds) {
      scheduleMicrotask(() async {
        final data = await rootBundle.load('assets/audios/$value');
        _soundIds[value] = await _pool.load(data);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pool.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> start() async {
    _play('start.mp3');
  }

  Future<void> clear() async {
    _play('clean.mp3');
  }

  Future<void> fall() async {
    _play('drop.mp3');
  }

  Future<void> rotate() async {
    _play('rotate.mp3');
  }

  Future<void> move() async {
    _play('move.mp3');
  }
}
