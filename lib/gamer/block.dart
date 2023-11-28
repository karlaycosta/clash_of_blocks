import 'game.dart';
import 'dart:math' as math;

/// Tipos de bloco
enum Tetriminos { I, L, J, Z, S, O, T }

/// Forma de cada bloco
const pieces = {
  Tetriminos.I: [
    [1, 1, 1, 1]
  ],
  Tetriminos.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  Tetriminos.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  Tetriminos.Z: [
    [1, 1, 0],
    [0, 1, 1],
  ],
  Tetriminos.S: [
    [0, 1, 1],
    [1, 1, 0],
  ],
  Tetriminos.O: [
    [1, 1],
    [1, 1]
  ],
  Tetriminos.T: [
    [0, 1, 0],
    [1, 1, 1]
  ]
};

typedef Position = ({int x, int y});

final class Block {
  /// Tipo de bloco
  final Tetriminos type;

  /// Forma do bloco
  final List<List<int>> piece;

  /// Posição do bloco
  final Position pos;
  int get x => pos.x;
  int get y => pos.y;

  final int rotateIndex;

  const Block(this.type, this.piece, this.pos, this.rotateIndex);

  /// Descer o bloco em N passos([step])
  Block fall({int step = 1}) =>
      Block(type, piece, (x: x, y: y + step), rotateIndex);

  /// Move o bloco em 1 passo para direita
  Block right() => Block(type, piece, (x: x + 1, y: y), rotateIndex);

  /// Move o bloco em 1 passo para direita
  Block left() => Block(type, piece, (x: x - 1, y: y), rotateIndex);

  /// Rotaciona o bloco em 90 graus no sentido horário
  Block rotate() {
    if (pos.y < 0) {
      return this;
    }
    switch (type) {
      case Tetriminos.I:
        final ({List<List<int>> piece, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              piece: [
                [1],
                [1],
                [1],
                [1]
              ],
              pos: (x: x + 1, y: y - 1),
              rot: 1,
            ),
          1 => (
              piece: [
                [1, 1, 1, 1],
              ],
              pos: (x: x - 1, y: y + 1),
              rot: 0,
            ),
          _ => (piece: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.piece, res.pos, res.rot);
      case Tetriminos.L:
        final ({List<List<int>> shape, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              shape: [
                [1, 0],
                [1, 0],
                [1, 1],
              ],
              pos: (x: x, y: y - 1),
              rot: 1,
            ),
          1 => (
              shape: [
                [1, 1, 1],
                [1, 0, 0],
              ],
              pos: (x: x, y: y + 1),
              rot: 2,
            ),
          2 => (
              shape: [
                [1, 1],
                [0, 1],
                [0, 1]
              ],
              pos: pos,
              rot: 3,
            ),
          3 => (
              shape: [
                [0, 0, 1],
                [1, 1, 1]
              ],
              pos: pos,
              rot: 0,
            ),
          _ => (shape: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.shape, res.pos, res.rot);
      case Tetriminos.J:
        final ({List<List<int>> shape, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              shape: [
                [1, 1],
                [1, 0],
                [1, 0],
              ],
              pos: pos,
              rot: 1,
            ),
          1 => (
              shape: [
                [1, 1, 1],
                [0, 0, 1],
              ],
              pos: pos,
              rot: 2,
            ),
          2 => (
              shape: [
                [0, 1],
                [0, 1],
                [1, 1]
              ],
              pos: pos,
              rot: 3,
            ),
          3 => (
              shape: [
                [1, 0, 0],
                [1, 1, 1]
              ],
              pos: pos,
              rot: 0,
            ),
          _ => (shape: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.shape, res.pos, res.rot);
      case Tetriminos.Z:
        final ({List<List<int>> shape, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              shape: [
                [0, 1],
                [1, 1],
                [1, 0],
              ],
              pos: pos,
              rot: 1,
            ),
          1 => (
              shape: [
                [1, 1, 0],
                [0, 1, 1],
              ],
              pos: pos,
              rot: 0,
            ),
          _ => (shape: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.shape, res.pos, res.rot);
      case Tetriminos.S:
        final ({List<List<int>> shape, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              shape: [
                [1, 0],
                [1, 1],
                [0, 1],
              ],
              pos: pos,
              rot: 1,
            ),
          1 => (
              shape: [
                [0, 1, 1],
                [1, 1, 0],
              ],
              pos: pos,
              rot: 0,
            ),
          _ => (shape: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.shape, res.pos, res.rot);
      case Tetriminos.O:
        return this;
      case Tetriminos.T:
        final ({List<List<int>> shape, Position pos, int rot}) res =
            switch (rotateIndex) {
          0 => (
              shape: [
                [1, 0],
                [1, 1],
                [1, 0],
              ],
              pos: (x: x, y: y - 1),
              rot: 1,
            ),
          1 => (
              shape: [
                [1, 1, 1],
                [0, 1, 0],
              ],
              pos: pos,
              rot: 2,
            ),
          2 => (
              shape: [
                [0, 1],
                [1, 1],
                [0, 1],
              ],
              pos: (x: x + 1, y: y),
              rot: 3,
            ),
          3 => (
              shape: [
                [0, 1, 0],
                [1, 1, 1],
              ],
              pos: (x: x - 1, y: y + 1),
              rot: 0,
            ),
          _ => (shape: piece, pos: pos, rot: rotateIndex),
        };
        return Block(type, res.shape, res.pos, res.rot);
    }
  }

  /// Método que verifica se o bloco atual pode continuar a se movimentar.
  /// Isso significa que o bloco não colidiu nos limites da tela ou
  /// em outra peça do jogo.
  ///
  /// Se retornar [true] significa que o bloco pode continuar.
  ///
  /// Se retornar [false] significa que o bloco colidiu.
  bool isValidInMatrix(List<List<int>> matrix) {
    // verifica se o bloco atual está dentro dos limites da tela
    if (y + piece.length > gamePadMatrixH ||
        x < 0 ||
        x + piece[0].length > gamePadMatrixW) {
      return false;
    }
    final below = y >= 0 ? y : 0;
    // verifica se o bloco atual colidiu com alguma
    // outra peça da [matrix]
    for (var y = below; y < gamePadMatrixH; y++) {
      for (var x = 0; x < gamePadMatrixW; x++) {
        if (matrix[y][x] == 1 && get(x, y) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  /// Verifica se existe uma peça do bloco na coodenada [x][y] fornecida.
  ///
  /// Retorna [1] se existe uma peça.
  ///
  /// Retorna [null] se não existir.
  int? get(int x, int y) {
    x -= this.x;
    y -= this.y;
    if (x < 0 || x >= piece[0].length || y < 0 || y >= piece.length) {
      return null;
    }
    return piece[y][x] == 1 ? 1 : null;
  }

  static Block fromType(Tetriminos type) => Block(type, pieces[type]!,
      type == Tetriminos.I ? (x: 3, y: 0) : (x: 4, y: -1), 0);

  /// Método estático que gera um bloco de forma aleatória.
  static Block getRandom() {
    final i = math.Random().nextInt(Tetriminos.values.length);
    return fromType(Tetriminos.values[i]);
  }
}
