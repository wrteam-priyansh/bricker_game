class Brick {
  final double bricX;
  final double brickY;
  final double brickWidth;
  final double brickHeight;
  final bool broken;

  Brick({
    required this.bricX,
    required this.brickHeight,
    required this.brickWidth,
    required this.brickY,
    required this.broken,
  });

  Brick breakBrick() {
    return Brick(bricX: this.bricX, brickHeight: this.brickHeight, brickWidth: this.brickWidth, brickY: this.brickY, broken: true);
  }
}
