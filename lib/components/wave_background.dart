import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(220, 220, 255, 1),
            Color.fromRGBO(180, 180, 255, 1),
          ],
          [
            Color.fromRGBO(255, 210, 255, 1),
            Color.fromRGBO(220, 220, 255, 1),
          ],
          [
            Color.fromRGBO(255, 50, 50, 1),
            Color.fromRGBO(255, 195, 255, .5),
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
      backgroundColor: Colors.blue[50],
    );
  }
}
