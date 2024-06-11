import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindwave_mobile2_example/graphs/histogram.dart';
import 'package:mindwave_mobile2_example/graphs/mainlive.dart';



class GraphSelectorScreen extends StatefulWidget {
  @override
  _GraphSelectorScreenState createState() => _GraphSelectorScreenState();
}

class _GraphSelectorScreenState extends State<GraphSelectorScreen> {
  String selectedGraph = 'Histogram';
  final List<String> graphTypes = ['Histogram', 'LineChart', 'PieChart'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Selector App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueAccent,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGraph,
                  icon: Icon(Icons.arrow_downward, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  dropdownColor: Colors.blueAccent,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGraph = newValue!;
                    });
                  },
                  items: graphTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
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
  @override
  Widget build(BuildContext context) {
    // Placeholder for Histogram
    return  BarChartSample4();
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChartSample2();
      
}
}

class PieChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 40,
            color: Colors.blue,
            title: '40%',
            titleStyle: TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.red,
            title: '30%',
            titleStyle: TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 15,
            color: Colors.green,
            title: '15%',
            titleStyle: TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 15,
            color: Colors.yellow,
            title: '15%',
            titleStyle: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
