import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Charts extends StatelessWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(), // 显示左边的标题
            topTitles: AxisTitles(),
          ),
          // 显示下边的标题),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(
                color: Color(0xff37434d),
                width: 1,
              ),
              bottom: BorderSide(
                color: Color(0xff37434d),
                width: 1,
              ),
            ),
          ),
          minX: 0,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(2, 1),
                FlSpot(4, 4),
                FlSpot(6, 2),
              ],
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

const complexGroupData = [
  {"date": "2021-10-01", "name": "A", "points": 1500},
  {"date": "2021-10-02", "name": "B", "points": 1600},
  {"date": "2021-10-03", "name": "C", "points": 1550},
  {"date": "2021-10-04", "name": "A", "points": 1650},
  {"date": "2021-10-05", "name": "B", "points": 1575},
  {"date": "2021-10-06", "name": "C", "points": 1625},
  {"date": "2021-10-07", "name": "A", "points": 1525},
  {"date": "2021-10-08", "name": "B", "points": 1680},
  {"date": "2021-10-09", "name": "C", "points": 1580},
  {"date": "2021-10-10", "name": "A", "points": 1700},
  {"date": "2021-10-11", "name": "B", "points": 1570},
  {"date": "2021-10-12", "name": "C", "points": 1680},
  {"date": "2021-10-13", "name": "A", "points": 1675},
  {"date": "2021-10-14", "name": "B", "points": 1600},
  {"date": "2021-10-15", "name": "C", "points": 1650},
  {"date": "2021-10-16", "name": "A", "points": 1650},
  {"date": "2021-10-17", "name": "B", "points": 1550},
  {"date": "2021-10-18", "name": "C", "points": 1700},
  {"date": "2021-10-19", "name": "A", "points": 1600},
  {"date": "2021-10-20", "name": "B", "points": 1650},
  {"date": "2021-10-21", "name": "C", "points": 1550},
  {"date": "2021-10-22", "name": "A", "points": 1700},
  {"date": "2021-10-23", "name": "B", "points": 1600},
  {"date": "2021-10-24", "name": "C", "points": 1650},
  {"date": "2021-10-25", "name": "A", "points": 1550},
  {"date": "2021-10-26", "name": "B", "points": 1700},
  {"date": "2021-10-27", "name": "C", "points": 1600},
  {"date": "2021-10-28", "name": "A", "points": 1650},
  {"date": "2021-10-29", "name": "B", "points": 1550},
  {"date": "2021-10-30", "name": "C", "points": 1700},
  {"date": "2021-10-31", "name": "A", "points": 1600}
];
