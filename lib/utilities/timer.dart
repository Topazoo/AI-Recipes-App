import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerWidget extends StatefulWidget {
  final int duration;

  const TimerWidget({Key? key, required this.duration}) : super(key: key);

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  late int _timeRemaining;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.duration;
  }

  void startTimer() {
    if (_isRunning || _timeRemaining == 0) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining < 1) {
        timer.cancel();
        _isRunning = false;
        FlutterRingtonePlayer.playAlarm(
          looping: false,
          volume: 0.1,
        );
      } else {
        if (mounted) {
          setState(() {
            _timeRemaining -= 1;
          });
        }
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    FlutterRingtonePlayer.stop();
  }

  void resetTimer() {
    setState(() {
      _timeRemaining = widget.duration;
    });
    stopTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: _timeRemaining);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds',
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: startTimer,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: stopTimer,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: resetTimer,
        ),
      ],
    );
  }
}
