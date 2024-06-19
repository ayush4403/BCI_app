import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LiveGraph extends StatefulWidget {
  final Stream<int> dataStream;
  final List<int> op;
  final int length;


  LiveGraph(
      {Key? key,
      required this.dataStream,
      required this.op,
      required this.length})
      : super(key: key);

  @override
  _LiveGraphState createState() => _LiveGraphState();
}

class _LiveGraphState extends State<LiveGraph> {
  final List<FlSpot> _dataPoints = [];
  double _xValue = 0;
  int meanval=0;

  @override
  void initState() {
    super.initState();

    widget.dataStream.listen((data) {
      _xValue += 1;

      _dataPoints.add(FlSpot(_xValue, data.toDouble()));
      if (_dataPoints.length > 10) {
        _dataPoints.removeAt(0);
      }
    });

  }

  Widget myapp(BuildContext context, String title, Stream<int> stream) {
    return StreamBuilder<int>(
        stream: stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              Text(snapshot.hasData ? "${snapshot.data}" : "N/A",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          );
        });
  }

  // void calmeanval(List<int> data) {
  //   int mean = 0;
  //   for (int i = 0; i < data.length; i++) {
  //     mean += data[i];
  //   }
  //   double val= mean/data.length;
  //   setState(() {
  //    meanval = val.toInt();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200, // Adjust this value to make the graph vertically smaller
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
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
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(color: Colors.white),
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
        if (widget.op.length < widget.length)
          Text("Your session data : ${widget.op}"),
         
      
      ],
    );
  }
}
