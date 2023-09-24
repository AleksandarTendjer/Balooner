import 'dart:ui';
import 'dart:async';
import 'dart:math';

class Balloon {
  final Paint paint;
  Rect rect;
  double speedX = 1.0; // Initial horizontal speed
  double speedY = 0.0; // Initial vertical speed
  double changeDirectionTime = 5.0; // Time to change direction (in seconds)
  double elapsedTime = 0.0; // Elapsed time since the last direction change

  Balloon(Color color, double x, double y)
      : paint = Paint()..color = color,
        rect = Rect.fromLTWH(x, y, 20, 20);

  void render(Canvas canvas) {
    canvas.drawOval(rect, paint);
  }

  void update(double dt) {
    elapsedTime += dt;

    rect = rect.translate(speedX, speedY);

    if (elapsedTime >= changeDirectionTime) {
      final random = Random();
      speedX = (random.nextDouble() - 0.5) * 2.0; // Random horizontal speed between -1 and 1
      speedY = (random.nextDouble() - 0.5) * 2.0; // Random vertical speed between -1 and 1

      elapsedTime = 0.0;
    }
  }
}
