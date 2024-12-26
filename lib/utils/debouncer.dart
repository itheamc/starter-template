import 'dart:async';
import 'dart:ui';

class Debouncer {
  Timer? _timer;

  void debounce(Duration duration, VoidCallback taskFunction) {
    resetTimer(); // Cancel any existing timer

    _timer = Timer(duration, () {
      taskFunction(); // Execute the task when the timer fires
    });
  }

  void resetTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel(); // Cancel any existing timer
    }
  }
}
