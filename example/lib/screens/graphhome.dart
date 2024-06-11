// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindwave_mobile2_example/graphs/histogram.dart';
import 'package:mindwave_mobile2_example/graphs/mainlive.dart';

class GraphSelectorScreen extends StatefulWidget {
  const GraphSelectorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GraphSelectorScreenState createState() => _GraphSelectorScreenState();
}

class _GraphSelectorScreenState extends State<GraphSelectorScreen> {
  String selectedGraph = 'Histogram';
  final List<String> graphTypes = ['Histogram', 'LineChart', 'PieChart'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Analysis'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: graphTypes.map((String graphType) {
              return ChoiceChip(
                label: Text(graphType),
                selected: selectedGraph == graphType,
                onSelected: (bool selected) {
                  setState(() {
                    selectedGraph = graphType;
                  });
                },
                selectedColor: Colors.blueAccent,
                backgroundColor: Colors.grey[800],
                labelStyle: TextStyle(
                  color: selectedGraph == graphType
                      ? Colors.white
                      : Colors.grey[400],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: getSelectedGraphWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectedGraphWidget() {
    switch (selectedGraph) {
      case 'Histogram':
        return HistogramChart();
      case 'LineChart':
        return LineChartSample();
      case 'PieChart':
        return PieChartSample();
      default:
        return Container();
    }
  }
}

class HistogramChart extends StatelessWidget {
  const HistogramChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for Histogram
    return BarChartSample4();
  }
}

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const LineChartSample2();
  }
}

class PieChartSample extends StatelessWidget {
  const PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 40,
            color: Colors.blue,
            title: '40%',
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.red,
            title: '30%',
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 15,
            color: Colors.green,
            title: '15%',
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 15,
            color: Colors.yellow,
            title: '15%',
            titleStyle: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
