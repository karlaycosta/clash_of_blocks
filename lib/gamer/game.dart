import 'dart:async';

import 'package:flutter/material.dart';

import '../material/audios.dart';
import 'block.dart';

/// O estado do [GameControl]
enum GameStates {
  none,
  paused,
  running,
  reset,
  mixing,
  clear,
  drop,
}

/// Altura da matriz
const gamePadMatrixH = 20;

/// Largura da matriz
const gamePadMatrixW = 10;

/// Duração da animação de cada linha quando o jogo
/// é reiniciado
const _resetLineDuration = Duration(milliseconds: 30);

/// Nível máximo de dificuldade do jogo
const _levelMax = 6;

/// Nível mínimo de dificuldade do jogo
const _levelMin = 1;

/// Velocidade de cada nível do jogo
const _speed = {
  1: 800,
  2: 650,
  3: 500,
  4: 370,
  5: 250,
  6: 160,
};

class Game extends StatefulWidget {
  final Widget child;
  final bool ghost;

  const Game({super.key, required this.child, this.ghost = true});

  @override
  State<StatefulWidget> createState() => GameControl();

  static GameControl of(BuildContext context) {
    final state = context.findAncestorStateOfType<GameControl>();
    assert(state != null, 'must wrap this context with [Game]');
    return state!;
  }
}

class GameControl extends State<Game> {
  GameControl() {
    // Inicia as matrizes [_data] e [_mask] com
    // os valores [0]
    for (int i = 0; i < gamePadMatrixH; i++) {
      _data.add(List.filled(gamePadMatrixW, 0));
      _mask.add(List.filled(gamePadMatrixW, 0));
    }
  }

  /// A matriz [_data] representa os blocos que já foram,
  /// salvos no jogo.
  final List<List<int>> _data = [];

  /// A matriz [_mask] tem a mesma largura e altura que [_data], e será
  /// combinada no método [build] com a matriz [_data] para formar uma
  /// nova matriz que será exibida na tela.
  /// Para qualquer valor na matriz [_mask]:
  ///
  /// Se o valor for [-1], significa que a linha em [_data] não é exibida.
  ///
  /// Se o valor for [0], não terá efeito em [_data].
  ///
  /// Se o valor for [1], significa que a linha em [_data] está destacada.
  final List<List<int>> _mask = [];

  /// Dificuldade atual do jogo
  int _level = 1;

  /// Total de pontos do jogo
  int _points = 0;

  /// Quantas linhas foram removidas do jogo
  int _cleared = 0;

  /// Bloco atual do jogo
  Block? _current;

  /// Bloco atual do jogo
  Block? _ghost;

  /// Próximo bloco do jogo
  Block _next = Block.getRandom();

  /// [Timer] que define o tempo de descida automático do jogo
  Timer? _autoFallTimer;

  /// [GameStates] Estado do jogo
  GameStates _states = GameStates.none;

  /// Método [get] que devolve o [Widget] de áudio
  SoundState get _sound => Sound.of(context);

  /// Método que retorna o próximo bloco e
  /// gera um novo próximo[_next] bloco.
  Block _getNext() {
    final next = _next; // guarda o bloco atual
    _next = Block.getRandom(); // Gera o próximo bloco
    return next; // retorna o bloco
  }

  /// Método que rotaciona o bloco.
  void rotate() {
    if (_current == null) return;

    if (_states != GameStates.running) return;
    // Gera um novo bloco rotacionado
    final next = _current!.rotate();
    // verifica se o novo bloco pode se movimentar
    if (next.isValidInMatrix(_data)) {
      setState(() {
        _current = next; // Salva o novo bloco
        _sound.rotate();
      });
    }
  }

  /// Método que move o bloco para direita.
  void right() {
    if (_states == GameStates.none && _level < _levelMax) {
      return setState(() => _level++);
    }
    if (_current == null) return;

    if (_states != GameStates.running) return;
    // Gera um novo bloco um passo a direita
    final next = _current!.right();
    // verifica se o novo bloco pode se movimentar
    if (next.isValidInMatrix(_data)) {
      setState(() {
        _current = next; // Salva o novo bloco
        _sound.move();
      });
    }
  }

  /// Método que move o bloco para esquerda.
  void left() {
    if (_states == GameStates.none && _level > _levelMin) {
      return setState(() => _level--);
    }
    if (_current == null) return;

    if (_states != GameStates.running) return;
    // Gera um novo bloco um passo a esquerda
    final next = _current!.left();
    // verifica se o novo bloco pode se movimentar
    if (next.isValidInMatrix(_data)) {
      setState(() {
        _current = next; // Salva o novo bloco
        _sound.move();
      });
    }
  }

  void drop() async {
    // if (_states == GameStates.paused || _states == GameStates.none) {
    //   _startGame();
    //   return;
    // }

    if (_current == null) return;

    if (_states != GameStates.running) return;

    for (int y = 0; y < gamePadMatrixH; y++) {
      final fall = _current!.fall(step: y + 1);
      if (fall.isValidInMatrix(_data) == false) {
        setState(() {
          _current = _current!.fall(step: y);
          _states = GameStates.drop;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        _mixCurrentIntoData(mixSound: _sound.fall);
        break;
      }
    }
  }

  /// Método que move o bloco para baixo.
  void down({bool enableSounds = true}) {
    if (_current == null) return;

    if (_states != GameStates.running) return;

    // cria um bloco um passo abaixo
    final next = _current!.fall();
    // verifica se o novo bloco pode se movimentar
    if (next.isValidInMatrix(_data)) {
      setState(() {
        _current = next; // Salva o novo bloco
        if (enableSounds) _sound.move();
      });
      return;
    }
    // atualiza os dados
    _mixCurrentIntoData();
  }

  void ghost() async {
    if (_current == null) return _ghost = null;
  
    if (_states != GameStates.running) return;

    _ghost = _current;
    for (int y = 0; y < gamePadMatrixH; y++) {
      final fall = _ghost!.fall(step: y + 1);
      if (fall.isValidInMatrix(_data) == false) {
        _ghost = _ghost!.fall(step: y);
        break;
      }
    }
  }

  /// Atualiza os dados do jogo
  ///
  /// Misture o bloco atual em [_data]
  Future<void> _mixCurrentIntoData({VoidCallback? mixSound}) async {
    if (_current == null) return;

    // cancela a descida automática
    _autoFall(false);

    _forTable((x, y) => _data[y][x] = _current?.get(x, y) ?? _data[y][x]);

    // lista que guarda as linhas que devem ser eliminadas
    final clearLines = <int>[];
    // percorre a tabela verificando se há linhas para serem eliminadas
    for (int i = 0; i < gamePadMatrixH; i++) {
      // verifica se todos os valores na linha é [1]
      if (_data[i].every((value) => value == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      setState(() => _states = GameStates.clear);

      _sound.clear();

      // efeito de animação que ocorre antes de remover a(s) linha(s)
      for (int count = 0; count < 5; count++) {
        for (final line in clearLines) {
          _mask[line].fillRange(0, gamePadMatrixW, count % 2 == 0 ? -1 : 1);
        }
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
      }

      for (final line in clearLines) {
        _mask[line].fillRange(0, gamePadMatrixW, 0);
      }

      // removendo a(s) linha(s)
      for (final line in clearLines) {
        _data.setRange(1, line + 1, _data); // Desce os blocos
        // adiciona uma nova linha em branco no topo da tabela
        _data[0] = List.filled(gamePadMatrixW, 0);
      }

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 100;

      //up level possible when cleared
      int level = (_cleared ~/ 10) + _levelMin;
      _level = level <= _levelMax && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      mixSound?.call(); // Executa o áudio que foi passado na chamada da função
      _forTable((x, y) => _mask[y][x] = _current?.get(x, y) ?? _mask[y][x]);
      setState(() {});
      Future.delayed(
        const Duration(milliseconds: 100),
        () => setState(() {
          _forTable((x, y) => _mask[y][x] = 0);
        }),
      );
    }

    // [_current] foi salvo em [_data],
    // portanto não é mais necessário
    // _current = null;
    _current = _getNext();

    // verifica se o jogo acabou, ou seja, verifica se
    // existe algum elemento na primeira linha com valor [1]
    if (_data[0].contains(1)) {
      reset();
      return;
    } else {
      // O jogo ainda não terminou, comece a próxima
      // rodada de queda do bloco
      _startGame();
    }
  }

  /// Método que percorre toda a tabela fornecendo
  /// um callback com as coodenadas [X,Y].
  void _forTable(void Function(int x, int y) function) {
    for (int y = 0; y < gamePadMatrixH; y++) {
      for (int x = 0; x < gamePadMatrixW; x++) {
        function(x, y);
      }
    }
  }

  /// TODO: Motor do jogo
  /// Função que ativa ou desativa a queda dos blocos
  void _autoFall(bool enable) {
    if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      _autoFallTimer = Timer.periodic(
        Duration(milliseconds: _speed[_level] ?? 200),
        (_) {
          down(enableSounds: false);
        },
      );
    } else {
      _autoFallTimer?.cancel();
      _autoFallTimer = null;
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      setState(() => _states = GameStates.paused);
    }
  }

  void pauseOrResume() {
    if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    } else if (_states == GameStates.running) {
      _autoFall(false);
      pause();
    }
  }

  void reset() {
    if (_states == GameStates.none) {
      // começar o jogo
      _startGame();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    _sound.start();
    _states = GameStates.reset;
    () async {
      int line = gamePadMatrixH;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 1;
        }
        setState(() {});
        await Future.delayed(_resetLineDuration);
        return line != 0;
      });
      _current = null;
      _getNext();
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 0;
        }
        setState(() {});
        line++;
        await Future.delayed(_resetLineDuration);
        return line != gamePadMatrixH;
      });
      setState(() {
        _states = GameStates.none;
      });
    }();
  }

  void _startGame() {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }
    setState(() {
      _states = GameStates.running;
      _autoFall(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ghost) {
      ghost();
    }
    final List<List<int>> mixed = [];
    for (var y = 0; y < gamePadMatrixH; y++) {
      mixed.add(List.filled(gamePadMatrixW, 0));
      for (var x = 0; x < gamePadMatrixW; x++) {
        int value = _current?.get(x, y) ?? _data[y][x];
        final ghost = _ghost?.get(x, y);
        if (value != 1 && ghost == 1) {
          value = 3;
        } else if (_mask[y][x] == -1) {
          value = 0;
        } else if (_mask[y][x] == 1) {
          value = 2;
        }
        mixed[y][x] = value;
      }
    }

    // teste(mixed);

    return GameState(
      mixed,
      _states,
      _level,
      _sound.mute,
      _points,
      _cleared,
      _next,
      child: widget.child,
    );
  }

  void soundSwitch() {
    setState(() {
      _sound.mute = !_sound.mute;
    });
  }

  void teste(List<List<int>> list) {
    final data = StringBuffer();
    data.writeln();
    data.writeln('|---data---| |---mask---| |--mixed---|');
    for (var x = 0; x < gamePadMatrixH; x++) {
      data.write('|');
      for (var y = 0; y < gamePadMatrixW; y++) {
        data.write(_data[x][y]);
      }
      data.write('| |');
      for (var y = 0; y < gamePadMatrixW; y++) {
        data.write(_mask[x][y]);
      }
      data.write('| |');
      for (var y = 0; y < gamePadMatrixW; y++) {
        data.write(list[x][y]);
      }
      data.writeln('|');
    }
    print(data);
  }
}

class GameState extends InheritedWidget {
  /// Dados de exibição da tela
  ///0: Bloco vazio
  ///1: Bloco normal
  ///2: Bloco destacado
  ///3: Bloco fantasma
  final List<List<int>> data;

  final GameStates states;

  final int level;

  final bool muted;

  final int points;

  final int cleared;

  final Block next;

  const GameState(
    this.data,
    this.states,
    this.level,
    this.muted,
    this.points,
    this.cleared,
    this.next, {
    super.key,
    required super.child,
  });

  static GameState of(BuildContext context) {
    final gameState = context.dependOnInheritedWidgetOfExactType<GameState>();
    assert(gameState != null, 'GameState não encontrado!');
    return gameState!;
  }

  static GameStates stateOf(BuildContext context) {
    final gameStates =
        context.getInheritedWidgetOfExactType<GameState>()?.states;
    assert(gameStates != null, 'GameState não encontrado!');
    return gameStates!;
  }

  @override
  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
