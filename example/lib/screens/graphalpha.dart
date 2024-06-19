import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindwave_mobile2/band_power.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';

class AlphaGraph extends StatefulWidget {
  AlphaGraph({Key? key}) : super(key: key);

  @override
  _AlphaGraphState createState() => _AlphaGraphState();
}

class _AlphaGraphState extends State<AlphaGraph> {
  final List<FlSpot> _dataPoints = [];
  double _xValue = 0;
  double? _minY, _maxY;
  final MindwaveMobile2 headset = MindwaveMobile2();

  @override
  void initState() {
    super.initState();
    final dataStream = headset.onBandPowerUpdate();

    dataStream.listen((data) {
      setState(() {
        _xValue += 1;
        final double yValue = data.highAlpha.toDouble() ;
        _dataPoints.add(FlSpot(_xValue, yValue));

        if (_minY == null || yValue < _minY!) {
          _minY = yValue;
        }

        if (_maxY == null || yValue > _maxY!) {
          _maxY = yValue;
        }

        if (_dataPoints.length > 1000) {
          _dataPoints.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: _minY ?? 0,
              maxY: _maxY ?? 100,
              lineBarsData: [
                LineChartBarData(
                  spots: _dataPoints,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  curveSmoothness: 0.5,
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: (_maxY! - _minY!) / 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(color: Colors.black),
                      );
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(),
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
