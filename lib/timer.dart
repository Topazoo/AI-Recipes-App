import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  final int duration;

  TimerWidget({required this.duration});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late int _timeRemaining;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.duration;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining < 1) {
        timer.cancel();
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
    _timer.cancel();
  }

  void resetTimer() {
    setState(() {
      _timeRemaining = widget.duration;
    });
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
          '${twoDigits(duration.inHours)}:${twoDigitMinutes}:${twoDigitSeconds}',
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: startTimer,
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: stopTimer,
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: resetTimer,
        ),
      ],
    );
  }
}